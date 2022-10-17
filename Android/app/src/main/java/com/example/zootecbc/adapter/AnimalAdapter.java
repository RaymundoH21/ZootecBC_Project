package com.example.zootecbc.adapter;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.zootecbc.R;
import com.example.zootecbc.model.Animal;
import com.example.zootecbc.nueva_captura;
import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.squareup.picasso.Picasso;

import java.text.DateFormat;

public class AnimalAdapter extends FirestoreRecyclerAdapter <Animal, AnimalAdapter.ViewHolder>{
    private FirebaseFirestore mFirestore = FirebaseFirestore.getInstance();
    Activity activity;

    /**
     * Create a new RecyclerView adapter that listens to a Firestore Query.  See {@link
     * FirestoreRecyclerOptions} for configuration options.
     *
     * @param options
     */
    public AnimalAdapter(@NonNull FirestoreRecyclerOptions<Animal> options, Activity activity) {
        super(options);
        this.activity = activity;
    }

    @Override
    protected void onBindViewHolder(@NonNull ViewHolder holder, int position, @NonNull Animal model) {

        DocumentSnapshot documentSnapshot = getSnapshots().getSnapshot(holder.getAdapterPosition());
        final String id = documentSnapshot.getId();


        holder.area.setText(model.getArea());
        holder.especie.setText(model.getEspecie());
        holder.raza.setText(model.getRaza());
        holder.tamaño.setText(model.getTamaño());
        holder.sexo.setText(model.getSexo());
        holder.edad.setText(model.getEdad());
        holder.color1.setText(model.getColor1());
        holder.color2.setText(model.getColor2());
        holder.fecha.setText(String.valueOf(model.getFecha()));

        String photoPet = model.getPhoto();
        try {
            if (!photoPet.equals(""))
                Picasso.with(activity.getApplicationContext())
                        .load(photoPet)
                        .resize(300, 300)
                        .into(holder.photo_pet);
        }catch (Exception e){
            Log.d("Exception", "e: "+e);
        }


        holder.btn_Editar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(activity,  nueva_captura.class);
                i.putExtra("id_animal", id);
                activity.startActivity(i);
            }
        });

        holder.btn_Eliminar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                deleteAnimal(id);
            }
        });
    }

    private void deleteAnimal(String id) {
        mFirestore.collection("Animales").document(id).delete().addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                Toast.makeText(activity,"El animal se ha eliminado correctamente",Toast.LENGTH_SHORT).show();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(activity,"Error al eliminar al animal",Toast.LENGTH_SHORT).show();
            }
        });
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.view_animal_single, parent, false);
        return new ViewHolder(v);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView area, especie, raza, tamaño, edad, sexo, color1, color2, fecha;
        ImageView btn_Eliminar, btn_Editar, photo_pet;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            area = itemView.findViewById(R.id.Area);
            especie = itemView.findViewById(R.id.Especie);
            tamaño = itemView.findViewById(R.id.Tamaño);
            sexo = itemView.findViewById(R.id.Sexo);
            edad = itemView.findViewById(R.id.Edad);
            color1 = itemView.findViewById(R.id.Color1);
            color2 = itemView.findViewById(R.id.Color2);
            raza = itemView.findViewById(R.id.Raza);
            fecha = itemView.findViewById(R.id.Fecha);
            photo_pet = itemView.findViewById(R.id.photo);
            btn_Eliminar = itemView.findViewById(R.id.btn_Eliminar);
            btn_Editar = itemView.findViewById(R.id.btn_Editar);
        }
    }

}
