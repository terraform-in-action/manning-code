import (
	"os"

	"github.com/hashicorp/terraform/helper/schema"
)

func resourceLocalFileDelete(d *schema.ResourceData, _ interface{}) error {
	os.Remove(d.Get("filename").(string))
	return nil
}
