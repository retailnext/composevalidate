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

package compose

import (
	"reflect"
	"strings"
	"testing"
)

const testComposeFileData = `---
version: "3.7"
services:
  elasticsearch:
    image: "docker.elastic.co/elasticsearch/elasticsearch:7.17.10@sha256:bc7ba1dc5067c5b3907b82c667a374cc987cd813501e1378ec74ccd1c577f787"
  ubuntu:
    image: "ubuntu:22.04"
`

var testExpectedImages = []string{
	"docker.elastic.co/elasticsearch/elasticsearch:7.17.10@sha256:bc7ba1dc5067c5b3907b82c667a374cc987cd813501e1378ec74ccd1c577f787",
	"ubuntu:22.04",
}

func TestGetImages(t *testing.T) {
	r := strings.NewReader(testComposeFileData)
	images, err := GetImages(r)
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(images, testExpectedImages) {
		t.Fatalf("wrong images: actual=%+v expected=%+v", images, testExpectedImages)
	}
}
