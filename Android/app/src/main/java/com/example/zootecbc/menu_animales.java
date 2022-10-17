package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.SearchView;

import com.example.zootecbc.adapter.AnimalAdapter;
import com.example.zootecbc.model.Animal;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

public class menu_animales extends AppCompatActivity {

    RecyclerView mRecycler;
    AnimalAdapter mAdapter;
    FirebaseFirestore mFirestore;

    SearchView search_view;
    Query query;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_animales);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        android.text.format.DateFormat df = new android.text.format.DateFormat();
        df.format("yyyy-MM-dd hh:mm:ss a", new java.util.Date());

        mFirestore = FirebaseFirestore.getInstance();
        mRecycler = findViewById(R.id.recyclerViewAnimales);
        mRecycler.setLayoutManager(new LinearLayoutManager(this));
        search_view = findViewById(R.id.search);
        query = mFirestore.collection("Animales");
        //Query query = mFirestore.collection("Animales").orderBy("Fecha", Query.Direction.DESCENDING);
        search_view.setQueryHint("Escriba un municipio");


        FirestoreRecyclerOptions<Animal> firestoreRecyclerOptions =
                new FirestoreRecyclerOptions.Builder<Animal>().setQuery(query.orderBy("Fecha", Query.Direction.DESCENDING), Animal.class).build();


        mAdapter = new AnimalAdapter(firestoreRecyclerOptions, this);
        mAdapter.notifyDataSetChanged();
        mRecycler.setAdapter(mAdapter);

        search_view();

    }

    private void search_view() {
        search_view.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String s) {
                textSearch(s);
                return false;
            }

            @Override
            public boolean onQueryTextChange(String s) {
                textSearch(s);
                return false;
            }
        });
    }
    public void textSearch(String s){
        FirestoreRecyclerOptions<Animal> firestoreRecyclerOptions =
                new FirestoreRecyclerOptions.Builder<Animal>()
                        .setQuery(query.orderBy("Area")
                                .startAt(s).endAt(s+"~"), Animal.class).build();
        mAdapter = new AnimalAdapter(firestoreRecyclerOptions, this);
        mAdapter.startListening();
        mRecycler.setAdapter(mAdapter);
    }


    @Override
    protected void onStart() {
        super.onStart();
        mAdapter.startListening();
    }

    @Override
    protected void onStop() {
        super.onStop();
        mAdapter.stopListening();
    }
}