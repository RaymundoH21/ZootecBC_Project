using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZootecBC.Repositories
{
    public interface IFirebaseRepository <T>
    {
       T Get(T model);
    }
}
