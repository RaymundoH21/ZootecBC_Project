package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.annotations.Nullable;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;
import com.squareup.picasso.Picasso;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class nueva_captura extends AppCompatActivity {

    private FirebaseFirestore mfirestore;
    private FirebaseAuth mAuth;
    StorageReference storageReference;
    String storage_path = "Animales/*";

    private static final int COD_SEL_STORAGE = 200;
    private static final int COD_SEL_IMAGE = 300;

    private Uri image_url;
    String photo = "photo";
    String idd;

    ProgressDialog progressDialog;

    ImageView photo_pet;

    Button btn_cu_photo, btn_r_photo;

    Button btn_add, btn_close;

    EditText etArea, etEspecie, etRaza, etTamaño, etEdad, etSexo, etColor1, etColor2;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nueva_captura);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        this.setTitle("Registrar Animal");
        //getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String id = getIntent().getStringExtra("id_animal");

        progressDialog = new ProgressDialog(this);

        mfirestore = FirebaseFirestore.getInstance();
        mAuth = FirebaseAuth.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();

        etArea = findViewById(R.id.area);
        etEspecie = findViewById(R.id.especie);
        etRaza = findViewById(R.id.raza);
        etTamaño = findViewById(R.id.tamaño);
        etEdad = findViewById(R.id.edad);
        etSexo = findViewById(R.id.sexo);
        etColor1 = findViewById(R.id.color1);
        etColor2 = findViewById(R.id.color2);
        btn_add = findViewById(R.id.btn_add);
        btn_close = findViewById(R.id.btn_close);

        photo_pet = findViewById(R.id.pet_photo);
        btn_cu_photo = findViewById(R.id.btn_photo);
        //btn_r_photo = findViewById(R.id.btn_remove_photo);


        btn_cu_photo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                uploadPhoto();
            }
        });

        /*btn_r_photo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("photo", "");
                mfirestore.collection("Animal").document(idd).update(map);
                Toast.makeText(nueva_captura.this, "Foto eliminada", Toast.LENGTH_SHORT).show();
            }
        });*/




        btn_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent c = new Intent(nueva_captura.this, menu_captura.class);
                startActivity(c);
            }
        });

        if (id == null || id == ""){
            idd = id;
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
                        Toast.makeText(getApplicationContext(), "Ingresar los datos ", Toast.LENGTH_SHORT).show();
                    }else{
                        postPet(areapet, especiepet, razapet, tamañopet,edadpet,sexopet, color1pet, color2pet);
                    }
                }
            });
        }else{
            idd = id;
            btn_add.setText("Actualizar");
            getAnimal(id);
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
                        Toast.makeText(getApplicationContext(), "Ingresar los datos", Toast.LENGTH_SHORT).show();
                    }else{
                        updateAnimal(areapet, especiepet, razapet, tamañopet,edadpet,sexopet, color1pet, color2pet, id);
                    }
                }
            });
        }



    }

    private void uploadPhoto() {
        Intent i = new Intent(Intent.ACTION_PICK);
        i.setType("image/*");

        startActivityForResult(i, COD_SEL_IMAGE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (resultCode == RESULT_OK) {
            if (requestCode == COD_SEL_IMAGE) {
                image_url = data.getData();
                subirPhoto(image_url);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void subirPhoto(Uri image_url) {
        progressDialog.setMessage("Actualizando foto");
        progressDialog.show();
        String id = getIntent().getStringExtra("id_animal");
        idd = id;
        String rute_storage_photo = storage_path + "" + photo + "" + mAuth.getUid() +""+ idd;
        StorageReference reference = storageReference.child(rute_storage_photo);
        reference.putFile(image_url).addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
            @Override
            public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                Task<Uri> uriTask = taskSnapshot.getStorage().getDownloadUrl();
                while (!uriTask.isSuccessful());
                if (uriTask.isSuccessful()){
                    uriTask.addOnSuccessListener(new OnSuccessListener<Uri>() {
                        @Override
                        public void onSuccess(Uri uri) {
                            String download_uri = uri.toString();
                            HashMap<String, Object> map = new HashMap<>();
                            map.put("photo", download_uri);
                            mfirestore.collection("Animales").document(idd).update(map);
                            Toast.makeText(nueva_captura.this, "Foto actualizada", Toast.LENGTH_SHORT).show();
                            progressDialog.dismiss();
                        }
                    });
                }
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(nueva_captura.this, "Error al cargar foto", Toast.LENGTH_SHORT).show();
            }
        });
    }



    private void updateAnimal(String areapet, String especiepet, String razapet, String tamañopet, String edadpet, String sexopet, String color1pet, String color2pet, String id) {
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

        mfirestore.collection("Animales").document(id).update(map).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                Toast.makeText(getApplicationContext(), "Actualizado exitosamente", Toast.LENGTH_SHORT).show();
                startActivity(new Intent(nueva_captura.this, menu_animales.class));
                finish();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(getApplicationContext(), "Error al actualizar", Toast.LENGTH_SHORT).show();
            }
        });

    }

    private void postPet(String areapet, String especiepet, String razapet, String tamañopet, String edadpet, String sexopet, String color1pet, String color2pet) {
        String idUser = mAuth.getCurrentUser().getUid();
        DocumentReference id = mfirestore.collection("Animales").document();
        Map<String, Object> map = new HashMap<>();
        map.put("id_user", idUser);
        map.put("id", id.getId());
        map.put("Area", areapet);
        map.put("Especie", especiepet);
        map.put("Raza", razapet);
        map.put("Tamaño", tamañopet);
        map.put("Edad", edadpet);
        map.put("Sexo", sexopet);
        map.put("Color1", color1pet);
        map.put("Color2", color2pet);
        map.put("Fecha", new Date().getTime());

        mfirestore.collection("Animales").document(id.getId()).set(map).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                Toast.makeText(getApplicationContext(), "Creado exitosamente", Toast.LENGTH_SHORT).show();
                finish();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(getApplicationContext(), "Error al ingresar", Toast.LENGTH_SHORT).show();
            }
        });

    }

    private void getAnimal(String id){
        mfirestore.collection("Animales").document(id).get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
            @Override
            public void onSuccess(DocumentSnapshot documentSnapshot) {
                String areaPet = documentSnapshot.getString("Area");
                String especiePet = documentSnapshot.getString("Especie");
                String razaPet = documentSnapshot.getString("Raza");
                String tamañoPet = documentSnapshot.getString("Tamaño");
                String edadPet = documentSnapshot.getString("Edad");
                String sexoPet = documentSnapshot.getString("Sexo");
                String color1Pet = documentSnapshot.getString("Color1");
                String color2Pet = documentSnapshot.getString("Color2");
                String photoPet = documentSnapshot.getString("photo");

                etArea.setText(areaPet);
                etEspecie.setText(especiePet);
                etRaza.setText(razaPet);
                etTamaño.setText(tamañoPet);
                etEdad.setText(edadPet);
                etSexo.setText(sexoPet);
                etColor1.setText(color1Pet);
                etColor2.setText(color2Pet);

                try {
                    if(!photoPet.equals("")){
                        Toast toast = Toast.makeText(getApplicationContext(), "Cargando foto", Toast.LENGTH_SHORT);
                        toast.setGravity(Gravity.TOP,0,200);
                        toast.show();
                        Picasso.with(nueva_captura.this)
                                .load(photoPet)
                                .resize(150, 150)
                                .into(photo_pet);
                    }
                }catch (Exception e) {
                    Log.v("Error", "e: " + e);
                }

                }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(getApplicationContext(), "Error al obtener los datos ", Toast.LENGTH_SHORT).show();
            }
        });
    }

   /* @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return false;
    }*/
}