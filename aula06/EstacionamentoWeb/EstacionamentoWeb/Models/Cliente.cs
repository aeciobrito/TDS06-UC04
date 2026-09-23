using System;
using System.Collections.Generic;

namespace EstacionamentoWeb.Models;

public partial class Cliente
{
    public int Id { get; set; }

    public string Nome { get; set; } = null!;

    public string Cpf { get; set; } = null!;

    public string? Telefone { get; set; }

    public virtual ICollection<Veiculo> Veiculos { get; set; } = new List<Veiculo>();
}
