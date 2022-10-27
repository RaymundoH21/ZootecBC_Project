using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ZootecBC.Models;

namespace ZootecBC.Repositories
{
    public class FirebaseRepository
    {
        private readonly string CollectionName;
        public FirestoreDb firestoreDb;
        public FirebaseRepository(string CollectionName) {
            string filePath = "/Users/MIRAGE/Downloads/google-services.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", filePath);
            firestoreDb = FirestoreDb.Create("{zootecbc}");
            this.CollectionName = CollectionName;
        }
        public T Get <T>(T record) where T : Firebasedocid
        {
            DocumentReference docRef = firestoreDb.Collection(CollectionName).Document(record.Id);
            DocumentSnapshot snapshot = docRef.GetSnapshotAsync().GetAwaiter().GetResult();
            if (snapshot.Exists)
            {
                T usr = snapshot.ConvertTo<T>();
                usr.Id = snapshot.Id;
                return usr;

            }
            else
            {
                return null;
            }
        }
    }
}