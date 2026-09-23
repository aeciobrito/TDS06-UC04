using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace EstacionamentoWeb.Models;

public partial class EstacionamentoDbContext : DbContext
{
    public EstacionamentoDbContext()
    {
    }

    public EstacionamentoDbContext(DbContextOptions<EstacionamentoDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<RegistrosEstacionamento> RegistrosEstacionamentos { get; set; }

    public virtual DbSet<Vaga> Vagas { get; set; }

    public virtual DbSet<Veiculo> Veiculos { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=EstacionamentoDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Clientes__3213E83FB0A5E2B3");

            entity.HasIndex(e => e.Cpf, "UQ__Clientes__D836E71F417877D3").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Cpf)
                .HasMaxLength(14)
                .IsUnicode(false)
                .HasColumnName("cpf");
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("nome");
            entity.Property(e => e.Telefone)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("telefone");
        });

        modelBuilder.Entity<RegistrosEstacionamento>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Registro__3213E83FB321555F");

            entity.ToTable("RegistrosEstacionamento");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DataHoraEntrada)
                .HasColumnType("datetime")
                .HasColumnName("data_hora_entrada");
            entity.Property(e => e.DataHoraSaida)
                .HasColumnType("datetime")
                .HasColumnName("data_hora_saida");
            entity.Property(e => e.VagaId).HasColumnName("vaga_id");
            entity.Property(e => e.ValorTotal)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valor_total");
            entity.Property(e => e.VeiculoId).HasColumnName("veiculo_id");

            entity.HasOne(d => d.Vaga).WithMany(p => p.RegistrosEstacionamentos)
                .HasForeignKey(d => d.VagaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Registro_Vaga");

            entity.HasOne(d => d.Veiculo).WithMany(p => p.RegistrosEstacionamentos)
                .HasForeignKey(d => d.VeiculoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Registro_Veiculo");
        });

        modelBuilder.Entity<Vaga>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Vagas__3213E83FEF399CCE");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Localizacao)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("localizacao");
            entity.Property(e => e.Tipo)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("tipo");
        });

        modelBuilder.Entity<Veiculo>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Veiculos__3213E83F0F165B40");

            entity.HasIndex(e => e.Placa, "UQ__Veiculos__0C057425D6F6A438").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClienteId).HasColumnName("cliente_id");
            entity.Property(e => e.Cor)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("cor");
            entity.Property(e => e.Modelo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("modelo");
            entity.Property(e => e.Placa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("placa");

            entity.HasOne(d => d.Cliente).WithMany(p => p.Veiculos)
                .HasForeignKey(d => d.ClienteId)
                .HasConstraintName("FK_Veiculo_Cliente");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
