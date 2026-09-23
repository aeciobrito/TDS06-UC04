using System;
using System.Collections.Generic;

namespace EstacionamentoWeb.Models;

public partial class Veiculo
{
    public int Id { get; set; }

    public int ClienteId { get; set; }

    public string Placa { get; set; } = null!;

    public string? Modelo { get; set; }

    public string? Cor { get; set; }

    public virtual Cliente Cliente { get; set; } = null!;

    public virtual ICollection<RegistrosEstacionamento> RegistrosEstacionamentos { get; set; } = new List<RegistrosEstacionamento>();
}
