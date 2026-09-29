using System;
using System.Collections.Generic;

namespace PizzariaSenac.Models;

public partial class Pedido
{
    public int Id { get; set; }

    public int? ClienteId { get; set; }

    public DateTime DataHora { get; set; }

    public string Status { get; set; } = null!;

    public decimal ValorTotal { get; set; }

    public virtual Cliente? Cliente { get; set; }

    public virtual ICollection<PedidoIten> PedidoItens { get; set; } = new List<PedidoIten>();
}
