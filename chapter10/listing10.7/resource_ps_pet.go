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

func resourcePSPetCreate(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	options := sdk.PetCreateOptions{
		Name:    d.Get("name").(string),
		Species: d.Get("species").(string),
		Age:     d.Get("age").(int),
	}

	pet, err := conn.Pets.Create(options)
	if err != nil {
		return err
	}

	d.SetId(pet.ID)
	resourcePSPetRead(d, meta)
	return nil
}

func resourcePSPetRead(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	pet, err := conn.Pets.Read(d.Id()) #A
	if err != nil {
		return err
	}
	d.Set("name", pet.Name) #B
	d.Set("species", pet.Species) #B
	d.Set("age", pet.Age) #B
	return nil
}
