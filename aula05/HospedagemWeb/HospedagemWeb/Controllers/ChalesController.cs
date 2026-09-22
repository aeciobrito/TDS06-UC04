using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HospedagemWeb.Models;

namespace HospedagemWeb.Controllers
{
    public class ChalesController : Controller
    {
        private readonly HospedagemDbContext _context;

        public ChalesController(HospedagemDbContext context)
        {
            _context = context;
        }

        // GET: Chales
        public async Task<IActionResult> Index()
        {
            return View(await _context.Chales.ToListAsync());
        }

        // GET: Chales/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var chale = await _context.Chales
                .FirstOrDefaultAsync(m => m.Id == id);
            if (chale == null)
            {
                return NotFound();
            }

            return View(chale);
        }

        // GET: Chales/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Chales/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Localizacao,Capacidade,ValorDiaria")] Chale chale)
        {
            if (ModelState.IsValid)
            {
                _context.Add(chale);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(chale);
        }

        // GET: Chales/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var chale = await _context.Chales.FindAsync(id);
            if (chale == null)
            {
                return NotFound();
            }
            return View(chale);
        }

        // POST: Chales/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Localizacao,Capacidade,ValorDiaria")] Chale chale)
        {
            if (id != chale.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(chale);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ChaleExists(chale.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(chale);
        }

        // GET: Chales/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var chale = await _context.Chales
                .FirstOrDefaultAsync(m => m.Id == id);
            if (chale == null)
            {
                return NotFound();
            }

            return View(chale);
        }

        // POST: Chales/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var chale = await _context.Chales.FindAsync(id);
            if (chale != null)
            {
                _context.Chales.Remove(chale);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ChaleExists(int id)
        {
            return _context.Chales.Any(e => e.Id == id);
        }
    }
}
