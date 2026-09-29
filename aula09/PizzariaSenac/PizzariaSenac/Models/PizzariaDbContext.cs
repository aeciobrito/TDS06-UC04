using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace PizzariaSenac.Models;

public partial class PizzariaDbContext : DbContext
{
    public PizzariaDbContext()
    {
    }

    public PizzariaDbContext(DbContextOptions<PizzariaDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<Pedido> Pedidos { get; set; }

    public virtual DbSet<PedidoIten> PedidoItens { get; set; }

    public virtual DbSet<Pizza> Pizzas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=PizzariaDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasIndex(e => e.Telefone, "UQ_Clientes_Telefone").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Endereco)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("endereco");
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("nome");
            entity.Property(e => e.Telefone)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("telefone");
        });

        modelBuilder.Entity<Pedido>(entity =>
        {
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClienteId).HasColumnName("cliente_id");
            entity.Property(e => e.DataHora)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("data_hora");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasDefaultValue("Em preparo")
                .HasColumnName("status");
            entity.Property(e => e.ValorTotal)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valor_total");

            entity.HasOne(d => d.Cliente).WithMany(p => p.Pedidos)
                .HasForeignKey(d => d.ClienteId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK_Pedidos_Clientes");
        });

        modelBuilder.Entity<PedidoIten>(entity =>
        {
            entity.HasKey(e => new { e.PedidoId, e.PizzaId });

            entity.ToTable("Pedido_Itens");

            entity.Property(e => e.PedidoId).HasColumnName("pedido_id");
            entity.Property(e => e.PizzaId).HasColumnName("pizza_id");
            entity.Property(e => e.Quantidade)
                .HasDefaultValue(1)
                .HasColumnName("quantidade");
            entity.Property(e => e.ValorUnitario)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valor_unitario");

            entity.HasOne(d => d.Pedido).WithMany(p => p.PedidoItens)
                .HasForeignKey(d => d.PedidoId)
                .HasConstraintName("FK_PedidoItens_Pedidos");

            entity.HasOne(d => d.Pizza).WithMany(p => p.PedidoItens)
                .HasForeignKey(d => d.PizzaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PedidoItens_Pizzas");
        });

        modelBuilder.Entity<Pizza>(entity =>
        {
            entity.HasIndex(e => e.Sabor, "UQ_Pizzas_Sabor").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Ingredientes)
                .IsUnicode(false)
                .HasColumnName("ingredientes");
            entity.Property(e => e.Sabor)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("sabor");
            entity.Property(e => e.Valor)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valor");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
