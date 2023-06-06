// Copyright 2023 RetailNext, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"os"
	"os/signal"

	"github.com/alecthomas/kong"
	"github.com/retailnext/composevalidate/compose"
	"github.com/retailnext/composevalidate/regctl"
	"go.uber.org/multierr"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var cli struct {
	Platform     string `kong:"help='Platform to validate',default='linux/amd64'"`
	Architecture string `kong:"help='Architecture to expect',default='amd64'"`
	ComposeYaml  string `kong:"required,arg,help='Docker Compose yaml containing services with images'"`
}

func getImages() (images []string, err error) {
	var f *os.File
	f, err = os.Open(cli.ComposeYaml)
	if err != nil {
		return
	}
	defer multierr.AppendInvoke(&err, multierr.Close(f))
	images, err = compose.GetImages(f)
	return
}

func checkImage(ctx context.Context, logger *zap.Logger, image string) {
	logger = logger.With(zap.String("image", image))
	arch, err := regctl.GetArchitecture(ctx, image, cli.Platform)
	if err != nil {
		logger.Fatal("failed to validate image", zap.Error(err))
	}
	if arch != cli.Architecture {
		logger.Fatal("image has incorrect architecture", zap.String("expected", cli.Architecture), zap.String("actual", arch))
	}
	logger.Info("image ok")
}

func setupLogger() (stdout zapcore.WriteSyncer, logger *zap.Logger) {
	stdout = zapcore.Lock(os.Stdout)
	consoleEncoder := zapcore.NewConsoleEncoder(zap.NewDevelopmentEncoderConfig())
	core := zapcore.NewCore(consoleEncoder, stdout, zap.NewAtomicLevel())
	logger = zap.New(core)
	return
}

func main() {
	_ = kong.Parse(&cli)
	_, logger := setupLogger()
	defer func(logger *zap.Logger) {
		_ = logger.Sync()
	}(logger)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()
	images, err := getImages()
	if err != nil {
		logger.Fatal("failed to get images", zap.Error(err))
	}
	for _, image := range images {
		checkImage(ctx, logger, image)
	}
	logger.Info("ok", zap.Int("checked_images", len(images)))
}
