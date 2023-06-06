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

package regctl

import (
	"context"
	"os/exec"
)

func run(ctx context.Context, args ...string) (stdout string, err error) {
	cmd := exec.CommandContext(ctx, "regctl", args...)
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(output), nil
}

func GetArchitecture(ctx context.Context, image, platform string) (architecture string, err error) {
	return run(ctx, "image", "inspect", "--platform", platform, "--format", "{{ .Architecture }}", image)
}
