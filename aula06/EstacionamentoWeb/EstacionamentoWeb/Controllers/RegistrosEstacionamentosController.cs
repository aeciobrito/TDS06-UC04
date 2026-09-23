using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using EstacionamentoWeb.Models;

namespace EstacionamentoWeb.Controllers
{
    public class RegistrosEstacionamentosController : Controller
    {
        private readonly EstacionamentoDbContext _context;

        public RegistrosEstacionamentosController(EstacionamentoDbContext context)
        {
            _context = context;
        }

        // GET: RegistrosEstacionamentos
        public async Task<IActionResult> Index()
        {
            var estacionamentoDbContext = _context.RegistrosEstacionamentos.Include(r => r.Vaga).Include(r => r.Veiculo);
            return View(await estacionamentoDbContext.ToListAsync());
        }

        // GET: RegistrosEstacionamentos/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var registrosEstacionamento = await _context.RegistrosEstacionamentos
                .Include(r => r.Vaga)
                .Include(r => r.Veiculo)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (registrosEstacionamento == null)
            {
                return NotFound();
            }

            return View(registrosEstacionamento);
        }

        // GET: RegistrosEstacionamentos/Create
        public IActionResult Create()
        {
            ViewData["VagaId"] = new SelectList(_context.Vagas, "Id", "Id");
            ViewData["VeiculoId"] = new SelectList(_context.Veiculos, "Id", "Id");
            return View();
        }

        // POST: RegistrosEstacionamentos/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,VeiculoId,VagaId,DataHoraEntrada,DataHoraSaida,ValorTotal")] RegistrosEstacionamento registrosEstacionamento)
        {
            if (ModelState.IsValid)
            {
                _context.Add(registrosEstacionamento);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["VagaId"] = new SelectList(_context.Vagas, "Id", "Id", registrosEstacionamento.VagaId);
            ViewData["VeiculoId"] = new SelectList(_context.Veiculos, "Id", "Id", registrosEstacionamento.VeiculoId);
            return View(registrosEstacionamento);
        }

        // GET: RegistrosEstacionamentos/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var registrosEstacionamento = await _context.RegistrosEstacionamentos.FindAsync(id);
            if (registrosEstacionamento == null)
            {
                return NotFound();
            }
            ViewData["VagaId"] = new SelectList(_context.Vagas, "Id", "Id", registrosEstacionamento.VagaId);
            ViewData["VeiculoId"] = new SelectList(_context.Veiculos, "Id", "Id", registrosEstacionamento.VeiculoId);
            return View(registrosEstacionamento);
        }

        // POST: RegistrosEstacionamentos/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,VeiculoId,VagaId,DataHoraEntrada,DataHoraSaida,ValorTotal")] RegistrosEstacionamento registrosEstacionamento)
        {
            if (id != registrosEstacionamento.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(registrosEstacionamento);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RegistrosEstacionamentoExists(registrosEstacionamento.Id))
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
            ViewData["VagaId"] = new SelectList(_context.Vagas, "Id", "Id", registrosEstacionamento.VagaId);
            ViewData["VeiculoId"] = new SelectList(_context.Veiculos, "Id", "Id", registrosEstacionamento.VeiculoId);
            return View(registrosEstacionamento);
        }

        // GET: RegistrosEstacionamentos/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var registrosEstacionamento = await _context.RegistrosEstacionamentos
                .Include(r => r.Vaga)
                .Include(r => r.Veiculo)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (registrosEstacionamento == null)
            {
                return NotFound();
            }

            return View(registrosEstacionamento);
        }

        // POST: RegistrosEstacionamentos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var registrosEstacionamento = await _context.RegistrosEstacionamentos.FindAsync(id);
            if (registrosEstacionamento != null)
            {
                _context.RegistrosEstacionamentos.Remove(registrosEstacionamento);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool RegistrosEstacionamentoExists(int id)
        {
            return _context.RegistrosEstacionamentos.Any(e => e.Id == id);
        }
    }
}
