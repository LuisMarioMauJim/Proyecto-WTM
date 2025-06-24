<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="AppWTM.Home"  MasterPageFile="~/Site.Master" %>

<asp:Content ID="Home" ContentPlaceHolderID="MainContent" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Inicio - Sistema de Tickets</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        :root {
            --amarillo: #fec526;
            --azul: #0f1d60;
            --rojo: #801250;
            --blanco: #ffffff;
            --gris-claro: #f5f7fa;
            --gris-borde: #e1e5eb;
        }
        
        body {
            background-color: var(--gris-claro);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }
        
        .profile-title {
            color: var(--azul);
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--amarillo);
        }
        
        .stat-card {
            background-color: var(--blanco);
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
            margin-bottom: 15px;
            border: none;
            color: #333;
        }
        
        .stat-card:hover {
            transform: translateY(-3px);
        }
        
        .stat-card.tickets {
            border-left: 4px solid var(--amarillo);
        }
        
        .stat-card.users {
            border-left: 4px solid var(--azul);
        }
        
        .stat-card.areas {
            border-left: 4px solid var(--rojo);
        }
        
        .stat-card.assigned {
            border-left: 4px solid #28a745;
        }
        
        .stat-card.unassigned {
            border-left: 4px solid #6c757d;
        }
        
        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: #333;
        }
        
        .chart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            padding: 20px;
            border: none;
            margin-bottom: 20px;
        }
        
        .tickets-list-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-top: 20px;
        }
        
        .ticket-item {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--gris-borde);
        }
        
        .ticket-item:hover {
            background-color: rgba(0, 0, 0, 0.02);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .ticket-id {
            font-weight: 700;
            color: var(--azul);
            width: 80px;
            flex-shrink: 0;
        }
        
        .ticket-priority {
            width: 100px;
            flex-shrink: 0;
            text-align: center;
        }
        
        .ticket-content {
            flex-grow: 1;
            padding: 0 15px;
        }
        
        .ticket-title {
            font-weight: 600;
            margin-bottom: 3px;
            color: #333;
        }
        
        .ticket-desc {
            color: #666;
            font-size: 0.9rem;
            display: -webkit-box;
            line-clamp: 1;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .ticket-status {
            width: 120px;
            flex-shrink: 0;
            text-align: center;
        }
        
        .ticket-date {
            width: 100px;
            flex-shrink: 0;
            text-align: right;
            color: #888;
            font-size: 0.85rem;
        }
        
        .priority-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.75rem;
            display: inline-block;
        }
        
        .priority-high {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }
        
        .priority-medium {
            background-color: rgba(254, 197, 38, 0.1);
            color: #b58d1a;
        }
        
        .priority-low {
            background-color: rgba(23, 162, 184, 0.1);
            color: #17a2b8;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.75rem;
            display: inline-block;
        }
        
        .status-open {
            background-color: rgba(0, 123, 255, 0.1);
            color: #007bff;
        }
        
        .status-closed {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        
        .status-pending {
            background-color: rgba(255, 193, 7, 0.1);
            color: #d4a100;
        }
        
        .status-cancelled {
            background-color: rgba(108, 117, 125, 0.1);
            color: #6c757d;
        }
        
        .status-activo {
            background-color: rgba(0, 123, 255, 0.1);
            color: #007bff;
        }

        .status-enproceso {
            background-color: rgba(23, 162, 184, 0.1);
            color: #17a2b8;
        }

        .status-resuelto {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }


        .section-title {
            color: var(--azul);
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
            color: var(--amarillo);
        }
        
        .action-btn {
            background-color: var(--amarillo);
            color: var(--azul);
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s;
            margin-top: 15px;
        }
        
        .action-btn:hover {
            background-color: #e6b422;
            color: var(--azul);
            transform: translateY(-2px);
        }
        .chart-container {
            height: 500px;
        }

        @media screen and (min-width: 1920px) {
            .chart-container {
                height: 700px !important;
            }
        }
    </style>
<body>
        <div class="container-fluid py-4">
            <div class="container-fluid">
                <!-- Fila 1 -->
                <div class="row mb-4">
                    <!-- Columna 1: Título + Gráfica -->
                    <div class="col-lg-8 col-md-12 pe-lg-3">
                        <h1 class="profile-title" >
                            <asp:Literal id="litBienvenida" runat="server" />
                        </h1>
                        <div class="chart-container">
                            <h5 class="section-title"><i class="fas fa-chart-line"></i> Mi creación de tickets en la semana</h5>
                            <canvas id="ticketsChart"></canvas>
                        </div>
                    </div>

                    <!-- Columna 2: Tarjetas -->
                    <div class="col-lg-4 col-md-12 d-flex flex-column">
                        <div id="divTotalTickets" runat="server" class="stat-card tickets p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-ticket-alt me-2"></i>Mis Tickets totales en el mes</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalTickets" runat="server" />
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <h5 class="section-title fw-bold">
                                Estadísticas generales
                            </h5>
                            <hr class="mt-1 mb-3" />
                        </div>
                        <div id="divUsuariosActivos" runat="server" class="stat-card users p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-users me-2"></i>Usuarios activos</h6>
                            <div class="stat-value" >
                                <asp:Literal ID="litUsuariosActivos" runat="server" />
                            </div>
                        </div>
                        <div id="divAreasActivas" runat="server"  class="stat-card areas p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-layer-group me-2"></i>Áreas activas</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litAreasActivas" runat="server"/>
                            </div>
                        </div>
                        <div id="divTicketsAsignados" runat="server" class="stat-card assigned p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-user-check me-2"></i>Tickets con Asignador en el mes</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litTicketsAsignados" runat="server" />
                            </div>
                        </div>
                        <div id="divTicketsSinAsignar" runat="server"  class="stat-card unassigned p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-question-circle me-2"></i>Tickets sin Asignador en el mes</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litTicketsSinAsignar" runat="server" />
                            </div>
                        </div>
                        <div id="divTicketsConDepartamento" runat="server"  class="stat-card unassigned p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-question-circle me-2"></i>Tickets sin Departamento en el mes</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litTicketSinDep" runat="server" />
                            </div>
                        </div>
                        <div id="divTicketsSinDepartamento" runat="server"  class="stat-card unassigned p-3 mb-3 flex-grow-1 d-flex flex-column justify-content-center text-start">
                            <h6 class="text-muted"><i class="fas fa-question-circle me-2"></i>Tickets con Departamento en el mes</h6>
                            <div class="stat-value">
                                <asp:Literal ID="litTicketConDep" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Fila 2: Lista de tickets -->
                <div class="row">
                    <div class="col-12">
                        <div class="tickets-list-container">
                            <h5 class="section-title"><i class="fas fa-history"></i> Mis últimos tickets</h5>

                            <!-- Repeater (simulado estáticamente con HTML) -->
                            <asp:Repeater ID="repeaterTickets" runat="server">
                                <ItemTemplate>
                                    <div class="ticket-item">
                                        <div class="ticket-id"><%# Eval("Id") %></div>
                                        <div class="ticket-priority"><span class='priority-badge <%# Eval("PrioridadCss") %>'><%# Eval("Prioridad") %></span></div>
                                        <div class="ticket-content">
                                            <div class="ticket-title"><%# Eval("Titulo") %></div>
                                            <div class="ticket-desc"><%# Eval("Descripcion") %></div>
                                        </div>
                                        <div class="ticket-status"><span class='status-badge <%# Eval("EstadoCss") %>'><%# Eval("Estado") %></span></div>
                                        <div class="ticket-date"><%# Eval("Fecha") %></div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        window.addEventListener('DOMContentLoaded', (event) => {
            const ctx = document.getElementById('ticketsChart').getContext('2d');
            const ticketsChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: <%= ChartLabels %>,
                datasets: [{
                    label: 'Tickets creados',
                    data: <%= ChartValues %>,
                    backgroundColor: 'rgba(254, 197, 38, 0.2)',
                    borderColor: '#fec526',
                    borderWidth: 3,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 2
                        }
                    }
                }
            }
        });
    });
    </script>

</body>
</asp:Content>
