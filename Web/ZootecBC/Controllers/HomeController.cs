using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZootecBC.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Ensenada()
        {
            ViewBag.Message = "Ensenada";
            return View();
        }
        public ActionResult Rosarito()
        {
            ViewBag.Message = "Rosarito";
            return View();
        }
        public ActionResult Tecate()
        {
            ViewBag.Message = "Tecate";
            return View();
        }
        public ActionResult Busqueda()
        {
            ViewBag.Message = "Busqueda";
            return View();
        }
    }
}