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
