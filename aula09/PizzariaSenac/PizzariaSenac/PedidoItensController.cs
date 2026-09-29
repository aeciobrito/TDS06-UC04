using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using PizzariaSenac.Models;

namespace PizzariaSenac
{
    public class PedidoItensController : Controller
    {
        private readonly PizzariaDbContext _context;

        public PedidoItensController(PizzariaDbContext context)
        {
            _context = context;
        }

        // GET: PedidoItens
        public async Task<IActionResult> Index()
        {
            var pizzariaDbContext = _context.PedidoItens.Include(p => p.Pedido).Include(p => p.Pizza);
            return View(await pizzariaDbContext.ToListAsync());
        }

        // GET: PedidoItens/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var pedidoIten = await _context.PedidoItens
                .Include(p => p.Pedido)
                .Include(p => p.Pizza)
                .FirstOrDefaultAsync(m => m.PedidoId == id);
            if (pedidoIten == null)
            {
                return NotFound();
            }

            return View(pedidoIten);
        }

        // GET: PedidoItens/Create
        public IActionResult Create()
        {
            ViewData["PedidoId"] = new SelectList(_context.Pedidos, "Id", "Id");
            ViewData["PizzaId"] = new SelectList(_context.Pizzas, "Id", "Id");
            return View();
        }

        // POST: PedidoItens/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("PedidoId,PizzaId,Quantidade,ValorUnitario")] PedidoIten pedidoIten)
        {
            if (ModelState.IsValid)
            {
                _context.Add(pedidoIten);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["PedidoId"] = new SelectList(_context.Pedidos, "Id", "Id", pedidoIten.PedidoId);
            ViewData["PizzaId"] = new SelectList(_context.Pizzas, "Id", "Id", pedidoIten.PizzaId);
            return View(pedidoIten);
        }

        // GET: PedidoItens/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var pedidoIten = await _context.PedidoItens.FindAsync(id);
            if (pedidoIten == null)
            {
                return NotFound();
            }
            ViewData["PedidoId"] = new SelectList(_context.Pedidos, "Id", "Id", pedidoIten.PedidoId);
            ViewData["PizzaId"] = new SelectList(_context.Pizzas, "Id", "Id", pedidoIten.PizzaId);
            return View(pedidoIten);
        }

        // POST: PedidoItens/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("PedidoId,PizzaId,Quantidade,ValorUnitario")] PedidoIten pedidoIten)
        {
            if (id != pedidoIten.PedidoId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(pedidoIten);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PedidoItenExists(pedidoIten.PedidoId))
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
            ViewData["PedidoId"] = new SelectList(_context.Pedidos, "Id", "Id", pedidoIten.PedidoId);
            ViewData["PizzaId"] = new SelectList(_context.Pizzas, "Id", "Id", pedidoIten.PizzaId);
            return View(pedidoIten);
        }

        // GET: PedidoItens/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var pedidoIten = await _context.PedidoItens
                .Include(p => p.Pedido)
                .Include(p => p.Pizza)
                .FirstOrDefaultAsync(m => m.PedidoId == id);
            if (pedidoIten == null)
            {
                return NotFound();
            }

            return View(pedidoIten);
        }

        // POST: PedidoItens/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var pedidoIten = await _context.PedidoItens.FindAsync(id);
            if (pedidoIten != null)
            {
                _context.PedidoItens.Remove(pedidoIten);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool PedidoItenExists(int id)
        {
            return _context.PedidoItens.Any(e => e.PedidoId == id);
        }
    }
}
