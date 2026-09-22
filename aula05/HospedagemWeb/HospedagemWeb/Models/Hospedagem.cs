using System;
using System.Collections.Generic;

namespace HospedagemWeb.Models;

public partial class Hospedagem
{
    public int Id { get; set; }

    public int ClienteId { get; set; }

    public int ChaleId { get; set; }

    public DateTime DataInicio { get; set; }

    public DateTime DataFim { get; set; }

    public decimal? Desconto { get; set; }

    public virtual Chale Chale { get; set; } = null!;

    public virtual Cliente Cliente { get; set; } = null!;
}
