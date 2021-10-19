package test

import (
	"bytes"
	"context"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"testing"

	"github.com/hashicorp/terraform-exec/tfexec"
	"github.com/hashicorp/terraform-exec/tfinstall"
	"github.com/rs/xid"
)

func TestTerraformModule(t *testing.T) {
	tmpDir, err := ioutil.TempDir("", "tfinstall")
	if err != nil {
		t.Error(err)
	}
	defer os.RemoveAll(tmpDir)

	ctx := context.Background()
	latestVersion := tfinstall.LatestVersion(tmpDir, false)
	execPath, err := tfinstall.Find(ctx, latestVersion)
	if err != nil {
		t.Error(err)
	}

	workingDir := "./testfixtures"
	tf, err := tfexec.NewTerraform(workingDir, execPath)
	if err != nil {
		t.Error(err)
	}

	err = tf.Init(ctx, tfexec.Upgrade(true))
	if err != nil {
		t.Error(err)
	}

	defer tf.Destroy(ctx)
	bucketName := fmt.Sprintf("bucket_name=%s", xid.New().String())
	err = tf.Apply(ctx, tfexec.Var(bucketName))
	if err != nil {
		t.Error(err)
	}

	state, err := tf.Show(context.Background())
	if err != nil {
		t.Error(err)
	}

	endpoint := state.Values.Outputs["endpoint"].Value.(string)
	url := fmt.Sprintf("http://%s", endpoint)
	resp, err := http.Get(url)
	if err != nil {
		t.Error(err)
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(resp.Body)
	t.Logf("\n%s", buf.String())

	if resp.StatusCode != http.StatusOK {
		t.Errorf("status code did not return 200")
	}
}
