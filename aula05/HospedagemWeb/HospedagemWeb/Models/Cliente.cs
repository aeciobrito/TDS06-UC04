using System;
using System.Collections.Generic;

namespace HospedagemWeb.Models;

public partial class Cliente
{
    public int Id { get; set; }

    public string Nome { get; set; } = null!;

    public string Rg { get; set; } = null!;

    public virtual ICollection<Hospedagem> Hospedagems { get; set; } = new List<Hospedagem>();
}
