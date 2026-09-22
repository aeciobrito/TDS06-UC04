using System;
using System.Collections.Generic;

namespace HospedagemWeb.Models;

public partial class Chale
{
    public int Id { get; set; }

    public string Localizacao { get; set; } = null!;

    public int Capacidade { get; set; }

    public decimal ValorDiaria { get; set; }

    public virtual ICollection<Hospedagem> Hospedagems { get; set; } = new List<Hospedagem>();
}
