package petstore

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
	sdk "github.com/terraform-in-action/go-petstore"
)

func TestAccPSPet_basic(t *testing.T) {
	resourceName := "petstore_pet.pet"

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testAccCheckPSPetDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccPSPetConfig_basic(),
				Check: resource.ComposeTestCheckFunc(
					resource.TestCheckResourceAttr(resourceName, "name", "Princess"),
					resource.TestCheckResourceAttr(resourceName, "species", "cat"),
					resource.TestCheckResourceAttr(resourceName, "age", "3"),
				),
			},
		},
	})
}

func testAccCheckPSPetDestroy(s *terraform.State) error {
	conn := testAccProvider.Meta().(*sdk.Client)
	for _, rs := range s.RootModule().Resources {
		if rs.Type != "petstore_pet" {
			continue
		}
		if rs.Primary.ID == "" {
			return fmt.Errorf("No instance ID is set")
		}
		_, err := conn.Pets.Read(rs.Primary.ID)
		if err != sdk.ErrResourceNotFound {
			return fmt.Errorf("Pet %s still exists", rs.Primary.ID)
		}
	}
	return nil
}

func testAccPSPetConfig_basic() string {
	return fmt.Sprintf(`
	resource "petstore_pet" "pet" {
		name    = "Princess"
		species = "cat"
		age     = 3
	  }
`)
}
