package petstore

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	sdk "github.com/terraform-in-action/go-petstore"
)

func resourcePSPet() *schema.Resource {
	return &schema.Resource{
		Create: resourcePSPetCreate,
		Read:   resourcePSPetRead,
		Update: resourcePSPetUpdate,
		Delete: resourcePSPetDelete,
		Importer: &schema.ResourceImporter{
			State: schema.ImportStatePassthrough,
		},

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
	return resourcePSPetRead(d, meta)
}

func resourcePSPetRead(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	pet, err := conn.Pets.Read(d.Id())
	if err != nil {
		return err
	}
	d.Set("name", pet.Name)
	d.Set("species", pet.Species)
	d.Set("age", pet.Age)
	return nil
}

func resourcePSPetUpdate(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	options := sdk.PetUpdateOptions{}
	if d.HasChange("name") {
		options.Name = d.Get("name").(string)
	}
	if d.HasChange("age") {
		options.Age = d.Get("age").(int)
	}
	conn.Pets.Update(d.Id(), options)
	return resourcePSPetRead(d, meta)
}

func resourcePSPetDelete(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	err := conn.Pets.Delete(d.Id())
	if err != nil {
		return err
	}
	return nil
}
