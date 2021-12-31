os.loadAPI("/class.lua"); class = class.class;

Animal = class({
    constructor = function(self,name,age,species)
        self.name = name
        self.age = age
        self.species = species
    end;
    speak = function(self)
        print("hi I'm " .. self.name)   
    end;
})