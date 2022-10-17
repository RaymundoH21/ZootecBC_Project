package com.example.zootecbc;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;

import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class CreatePetFragment extends DialogFragment {

    private FirebaseFirestore mfirestore;

    Button btn_add;

    EditText etArea, etEspecie, etRaza, etTamaño, etEdad, etSexo, etColor1, etColor2;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        android.text.format.DateFormat df = new android.text.format.DateFormat();
        df.format("yyyy-MM-dd hh:mm:ss a", new java.util.Date());

        // Inflate the layout for this fragment
        View v = inflater.inflate(R.layout.fragment_create_pet, container, false);
        mfirestore = FirebaseFirestore.getInstance();

        etArea = v.findViewById(R.id.area);
        etEspecie = v.findViewById(R.id.especie);
        etRaza = v.findViewById(R.id.raza);
        etTamaño = v.findViewById(R.id.tamaño);
        etEdad = v.findViewById(R.id.edad);
        etSexo = v.findViewById(R.id.sexo);
        etColor1 = v.findViewById(R.id.color1);
        etColor2 = v.findViewById(R.id.color2);
        btn_add = v.findViewById(R.id.btn_add);

        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String areapet = etArea.getText().toString().trim();
                String especiepet = etEspecie.getText().toString().trim();
                String razapet = etRaza.getText().toString().trim();
                String tamañopet = etTamaño.getText().toString().trim();
                String edadpet = etEdad.getText().toString().trim();
                String sexopet = etSexo.getText().toString().trim();
                String color1pet = etColor1.getText().toString().trim();
                String color2pet = etColor2.getText().toString().trim();

                if (areapet.isEmpty() && especiepet.isEmpty() && razapet.isEmpty() && tamañopet.isEmpty() && edadpet.isEmpty() && sexopet.isEmpty() && color1pet.isEmpty() && color2pet.isEmpty()){
                    Toast.makeText(getContext(), "Ingresar los datos", Toast.LENGTH_SHORT).show();
                }else{
                    postPet(areapet, especiepet, razapet, tamañopet,edadpet,sexopet, color1pet, color2pet);
                }
            }
        });

        return v;
    }
    private void postPet(String areapet, String especiepet, String razapet, String tamañopet, String edadpet, String sexopet, String color1pet, String color2pet) {

        android.text.format.DateFormat df = new android.text.format.DateFormat();
        df.format("yyyy-MM-dd hh:mm:ss a", new java.util.Date());

        Map<String, Object> map = new HashMap<>();
        map.put("Area", areapet);
        map.put("Especie", especiepet);
        map.put("Raza", razapet);
        map.put("Tamaño", tamañopet);
        map.put("Edad", edadpet);
        map.put("Sexo", sexopet);
        map.put("Color1", color1pet);
        map.put("Color2", color2pet);
        map.put("Fecha", new Date().getTime());

        mfirestore.collection("Animales").add(map).addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
            @Override
            public void onSuccess(DocumentReference documentReference) {
                Toast.makeText(getContext(), "Creado exitosamente", Toast.LENGTH_SHORT).show();
                getDialog().dismiss();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(getContext(), "Error al ingresar", Toast.LENGTH_SHORT).show();
            }
        });

    }

}