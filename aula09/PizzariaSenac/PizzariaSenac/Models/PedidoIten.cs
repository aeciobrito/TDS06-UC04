using System;
using System.Collections.Generic;

namespace PizzariaSenac.Models;

public partial class PedidoIten
{
    public int PedidoId { get; set; }

    public int PizzaId { get; set; }

    public int Quantidade { get; set; }

    public decimal ValorUnitario { get; set; }

    public virtual Pedido Pedido { get; set; } = null!;

    public virtual Pizza Pizza { get; set; } = null!;
}
