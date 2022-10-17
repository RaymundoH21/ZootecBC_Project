package com.example.zootecbc.model;

public class Animal {
    String Area, Especie, Raza, Tamaño,Edad, Sexo, Color1, Color2, photo;
    long Fecha;
    public Animal(){}

    public Animal(String Area, String Especie, String Raza, String Tamaño, String Edad, String Sexo, String Color1, String Color2, String photo, long Fecha) {
        this.Area = Area;
        this.Especie = Especie;
        this.Raza = Raza;
        this.Tamaño = Tamaño;
        this.Edad = Edad;
        this.Sexo = Sexo;
        this.Color1 = Color1;
        this.Color2 = Color2;
        this.Fecha = Fecha;
        this.photo = photo;
    }

    public String getArea() {
        return Area;
    }

    public void setArea(String area) {
        Area = area;
    }

    public String getEspecie() {
        return Especie;
    }

    public void setEspecie(String especie) {
        Especie = especie;
    }

    public String getRaza() {
        return Raza;
    }

    public void setRaza(String raza) {
        Raza = raza;
    }

    public String getTamaño() {
        return Tamaño;
    }

    public void setTamaño(String tamaño) {
        Tamaño = tamaño;
    }

    public String getEdad() {
        return Edad;
    }

    public void setEdad(String edad) {
        Edad = edad;
    }

    public String getSexo() {
        return Sexo;
    }

    public void setSexo(String sexo) {
        Sexo = sexo;
    }

    public String getColor1() {
        return Color1;
    }

    public void setColor1(String color1) {
        Color1 = color1;
    }

    public String getColor2() {
        return Color2;
    }

    public void setColor2(String color2) {
        Color2 = color2;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public long getFecha() {
        return Fecha;
    }

    public void setFecha(long fecha) {
        Fecha = fecha;
    }
}
