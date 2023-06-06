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
	"testing"
)

func TestGetArchitecture(t *testing.T) {
	_, err := exec.LookPath("regctl")
	if err != nil {
		t.Skipf("regctl not found in PATH: %+v", err)
	}
	ctx, cancelCtx := context.WithCancel(context.Background())
	t.Cleanup(cancelCtx)

	var cases = []struct {
		Image        string
		Platform     string
		Architecture string
		ExpectError  bool
	}{
		{Image: "ubuntu", Platform: "linux/magicqusp", ExpectError: true},
		{Image: "ubuntu:22.04", Platform: "linux/amd64", Architecture: "amd64"},
		{Image: "ubuntu:12.04", Platform: "linux/arm64", Architecture: "amd64"},
	}

	for caseIdx, caseData := range cases {
		arch, err := GetArchitecture(ctx, caseData.Image, caseData.Platform)
		if caseData.ExpectError {
			if err == nil {
				t.Fatalf("%d: expected error but got non-error architecture=%q", caseIdx, arch)
			} // else OK
		} else {
			if err != nil {
				t.Fatalf("%d: unexpected error=%+v", caseIdx, err)
			} else if arch != caseData.Architecture {
				t.Fatalf("%d: incorrect result expected=%q actual=%q", caseIdx, caseData.Architecture, arch)
			} // else OK
		}
	}
}
