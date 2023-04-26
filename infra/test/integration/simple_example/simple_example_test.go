// Copyright 2023 Google LLC
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

package simple_example

import (
	"fmt"
    "net/http"
    "time"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestSimpleExample(t *testing.T) {
	const databaseVersion = `MYSQL_8_0`

	// initialize Terraform test from the Blueprints test framework
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {

		dbIP := example.GetStringOutput("db_ip")
		//op := gcloud.Run(t, "sql instances describe")
		fmt.Print(dbIP)
		//fmt.Print(op.String())
		assert.NotEmpty(dbIP, "db_ip")

        // sample e2e to assert app is working
		wikiURL := example.GetStringOutput("xwiki_url")
		isServing := func() (bool, error) {
			resp, err := http.Get(wikiURL)
			if err != nil || resp.StatusCode != 200 {
				// retry if err or status not 200
				return true, nil
			}
			return false, nil
		}
		utils.Poll(t, isServing, 20, time.Second*20)

	})

	example.Test()
}
