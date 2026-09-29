using System;
using System.Collections.Generic;

namespace PizzariaSenac.Models;

public partial class Pizza
{
    public int Id { get; set; }

    public string Sabor { get; set; } = null!;

    public string? Ingredientes { get; set; }

    public decimal Valor { get; set; }

    public virtual ICollection<PedidoIten> PedidoItens { get; set; } = new List<PedidoIten>();
}
