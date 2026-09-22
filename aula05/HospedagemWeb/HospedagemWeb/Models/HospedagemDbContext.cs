using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace HospedagemWeb.Models;

public partial class HospedagemDbContext : DbContext
{
    public HospedagemDbContext()
    {
    }

    public HospedagemDbContext(DbContextOptions<HospedagemDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Chale> Chales { get; set; }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<Hospedagem> Hospedagems { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=HospedagemDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Chale>(entity =>
        {
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Capacidade).HasColumnName("capacidade");
            entity.Property(e => e.Localizacao)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("localizacao");
            entity.Property(e => e.ValorDiaria)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valorDiaria");
        });

        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasIndex(e => e.Rg, "UQ_Clientes_RG").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("nome");
            entity.Property(e => e.Rg)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("rg");
        });

        modelBuilder.Entity<Hospedagem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Hospedagens");

            entity.ToTable("Hospedagem");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChaleId).HasColumnName("chale_id");
            entity.Property(e => e.ClienteId).HasColumnName("cliente_id");
            entity.Property(e => e.DataFim)
                .HasColumnType("datetime")
                .HasColumnName("dataFim");
            entity.Property(e => e.DataInicio)
                .HasColumnType("datetime")
                .HasColumnName("dataInicio");
            entity.Property(e => e.Desconto)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("desconto");

            entity.HasOne(d => d.Chale).WithMany(p => p.Hospedagems)
                .HasForeignKey(d => d.ChaleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hosp_Chales");

            entity.HasOne(d => d.Cliente).WithMany(p => p.Hospedagems)
                .HasForeignKey(d => d.ClienteId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hosp_Clientes");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
