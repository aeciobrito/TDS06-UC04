using System;
using System.Collections.Generic;

namespace EstacionamentoWeb.Models;

public partial class Vaga
{
    public int Id { get; set; }

    public string Localizacao { get; set; } = null!;

    public string? Tipo { get; set; }

    public virtual ICollection<RegistrosEstacionamento> RegistrosEstacionamentos { get; set; } = new List<RegistrosEstacionamento>();
}
