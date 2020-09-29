package petstore

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/terraform"
	sdk "github.com/scottwinkler/go-petstore"
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
					resource.TestCheckResourceAttr(resourceName, "name", "Winston"),
					resource.TestCheckResourceAttr(resourceName, "species", "cat"),
					resource.TestCheckResourceAttr(resourceName, "age", "2"),
				),
			},
		},
	})
}

func testAccCheckPSPetDestroy(s *terraform.State) error {
	for _, rs := range s.RootModule().Resources {
		if rs.Type != "petstore_pet" {
			continue
		}
		if rs.Primary.ID == "" {
			return fmt.Errorf("No instance ID is set")
		}
		conn := testAccProvider.Meta().(*sdk.Client)
		pet, err := conn.Pets.Read(rs.Primary.ID)
		if err != sdk.ErrResourceNotFound {
			return fmt.Errorf("Pet %s still exists", pet.ID)
		}
	}
	return nil
}

func testAccPSPetConfig_basic() string {
	return fmt.Sprintf(`
	resource "petstore_pet" "pet" {
		name = "Winston"
		species = "cat"
		age = 2
	  }
`)
}
