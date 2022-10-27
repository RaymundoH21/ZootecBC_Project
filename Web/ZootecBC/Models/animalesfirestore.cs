using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZootecBC.Models
{
    public class animalesfirestore : Firebasedocid
    {
        [FirestoreProperty]
        public string Area { get; set; }
        [FirestoreProperty]
        public string Color1 { get; set; }
        [FirestoreProperty]
        public string Color2 { get; set; }
        [FirestoreProperty]
        public string Edad { get; set; }
        [FirestoreProperty]
        public string Especie { get; set; }
        [FirestoreProperty]
        public int Fecha { get; set; }
        [FirestoreProperty]
        public string Raza { get; set; }
        [FirestoreProperty]
        public string Sexo { get; set; }
        [FirestoreProperty]
        public string Tamaño { get; set; }
        [FirestoreProperty]
        public string photo { get; set; }
    }
}