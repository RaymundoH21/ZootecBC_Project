using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FireSharp;
using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;
using Newtonsoft.Json;


namespace ZootecBC.Controllers
{
    public class MantenedorController : Controller
    {

        IFirebaseClient cliente;
        public MantenedorController()
        {

            IFirebaseConfig config = new FirebaseConfig
            {
                AuthSecret = "IPdgJrVvwbeM1BbbiGxN0qgulQFfG4uGVXR4wmB0",
                BasePath = "https://zootecbc-default-rtdb.firebaseio.com/"

            };
            cliente = new FirebaseClient(config);
        }
        // GET: Mantenedor
        public ActionResult Index()
        {
            return View();
        }

        // GET: Mantenedor/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Mantenedor/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Mantenedor/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Mantenedor/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Mantenedor/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Mantenedor/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Mantenedor/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
