package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
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
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class nueva_captura extends AppCompatActivity {

    FirebaseAuth mAuth;
    FirebaseFirestore mFirestore;
    /*
    StorageReference storageReference;
    String storage_path = "Animales/*";

    private static final int COD_SEL_STORAGE = 200;
    private static final int COD_SEL_iMAGE = 300;

    private Uri image_url;
    String photo = "photo";
    String idd;
    */
    ProgressDialog progressDialog;

    ImageView mImageViewFotoAnimal;

    EditText mTextArea;
    EditText mTextEspecie;
    EditText mTextSexo;
    EditText mTextEdad;
    EditText mTextColor1;
    EditText mTextColor2;
    EditText mTextRaza;

    Button mButtonCrear;
    Button cancelar;

    /*
    Button mButtonSubirFoto;
    Button mButtonBorrarFoto;
    */


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nueva_captura);

        mAuth = FirebaseAuth.getInstance();
        mFirestore = FirebaseFirestore.getInstance();
        //storageReference = FirebaseStorage.getInstance().getReference();

        mImageViewFotoAnimal =(ImageView) findViewById(R.id.ivFotoanimal);

        mTextArea=(EditText) findViewById(R.id.etArea);
        mTextEspecie=(EditText) findViewById(R.id.etEspecie);
        mTextSexo=(EditText) findViewById(R.id.etSexo);
        mTextEdad=(EditText) findViewById(R.id.etEdad);
        mTextColor1=(EditText) findViewById(R.id.etColor1);
        mTextColor2=(EditText) findViewById(R.id.etColor2);
        mTextRaza=(EditText) findViewById(R.id.etRaza);

        mButtonCrear=(Button) findViewById(R.id.btn_subir);
       // mButtonSubirFoto=(Button) findViewById(R.id.btnSubirfoto);
       // mButtonBorrarFoto=(Button) findViewById(R.id.btnEliminarfoto);
        cancelar=(Button) findViewById(R.id.btn_Cancelar);

        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));
/*
        mButtonSubirFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                UploadFoto();
            }
        });*/
        mButtonCrear.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                crearDatos();
            }
        });

        cancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent e = new Intent(nueva_captura.this, menu_captura.class);
                startActivity(e);
            }
        });

        /*camara.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    Intent intent = new Intent();
                    intent.setAction(MediaStore.ACTION_IMAGE_CAPTURE);
                    startActivity(intent);
                }
                catch (Exception e){
                    e.printStackTrace();
                }
            }
        });*/
    }

    private void crearDatos(){

        String area = mTextArea.getText().toString();
        String color1 = mTextColor1.getText().toString();
        String color2 = mTextColor2.getText().toString();
        String edad = mTextEdad.getText().toString();
        String especie = mTextEspecie.getText().toString();
        String raza = mTextRaza.getText().toString();
        String sexo = mTextSexo.getText().toString();

        Map<String, Object> map = new HashMap<>();
        map.put("Area", area);
        map.put("Color1", color1);
        map.put("Color2", color2);
        map.put("Edad", edad);
        map.put("Especie", especie);
        map.put("Raza", raza);
        map.put("Sexo", sexo);
        map.put("Fecha", new Date().getTime());

        mFirestore.collection("Animales").add(map).addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
            @Override
            public void onSuccess(DocumentReference documentReference) {
                Toast.makeText(nueva_captura.this, "El animal se ha capturado correctamente", Toast.LENGTH_SHORT).show();
                startActivity(new Intent(nueva_captura.this, menu_captura.class));
                finish();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(nueva_captura.this, "El animal no se capturo correctamente", Toast.LENGTH_SHORT).show();
            }
        });

        //mFirestore.collection("Animales").document().set(map);
    }
    /*
    private  void UploadFoto(){
        Intent i = new Intent(Intent.ACTION_PICK);
        i.setType("Animales/*");

        startActivityForResult(i, COD_SEL_iMAGE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (resultCode == RESULT_OK){
            if (requestCode == COD_SEL_iMAGE){
                image_url = data.getData();
                subirFoto(image_url);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void subirFoto(Uri image_url){
        progressDialog.setMessage("Actualizando foto");
        progressDialog.show();

        String rute_storage_photo = storage_path + "" + photo + "" + mAuth.getUid() + "" + idd;
        StorageReference reference = storageReference.child(rute_storage_photo);
        reference.putFile(image_url).addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
            @Override
            public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                Task<Uri>   uriTask = taskSnapshot.getStorage().getDownloadUrl();
                while (!uriTask.isSuccessful());
                if (uriTask.isSuccessful()){
                    uriTask.addOnSuccessListener(new OnSuccessListener<Uri>() {
                        @Override
                        public void onSuccess(Uri uri) {
                            String download_uri = uri.toString();
                            HashMap<String, Object> map = new HashMap<>();
                            map.put("photo", download_uri);
                            mFirestore.collection("Animales").document(idd).update(map);
                            Toast.makeText(nueva_captura.this, "Foto actualizada", Toast.LENGTH_SHORT).show();
                            progressDialog.dismiss();
                        }
                    });
                }
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(nueva_captura.this, "Error al cargar la foto", Toast.LENGTH_SHORT).show();
            }
        });
    }

     */
}