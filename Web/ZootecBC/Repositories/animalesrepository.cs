using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ZootecBC.Models;

namespace ZootecBC.Repositories
{
    public class animalesrepository : IFirebaseRepository<animalesfirestore>
    {
        private readonly string ColletionName = "Animales";
        private readonly FirebaseRepository firebaseRepository;
        public animalesrepository() {
            firebaseRepository = new FirebaseRepository(ColletionName);
        }
        public animalesfirestore Get(animalesfirestore model) => firebaseRepository.Get(model); 
    }
}