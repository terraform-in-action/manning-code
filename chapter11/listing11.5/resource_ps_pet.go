package petstore

import (
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	sdk "github.com/scottwinkler/go-petstore"
)

func resourcePSPet() *schema.Resource {
	return &schema.Resource{ 
		Create: resourcePSPetCreate,
		Read:   resourcePSPetRead,
		Update: resourcePSPetUpdate,
		Delete: resourcePSPetDelete,

		Schema: map[string]*schema.Schema{
			"name": {
				Type:     schema.TypeString,
				Optional: true,
				Default:  "",
			},
			"species": {
				Type:     schema.TypeString,
				ForceNew: true,
				Required: true,
			},
			"age": {
				Type:     schema.TypeInt,
				Required: true,
			},
		},
	}
}
