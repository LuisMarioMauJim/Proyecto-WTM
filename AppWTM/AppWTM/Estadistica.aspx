<%@ Page Title="" Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Estadistica.aspx.cs" Inherits="AppWTM.Estadistica" %>

<asp:Content ID="Estadisticas" ContentPlaceHolderID="MainContent" runat="server">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gráfico de Tickets por Área</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <!-- Bootstrap JS + Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* [Aquí va todo el contenido de tu etiqueta <style> original] */
        :root {
            --color-primary: #0f1d60;   /* Azul oscuro */
            --color-secondary: #801250; /* Vino / púrpura */
            --color-accent: #fec526;    /* Amarillo */
            --color-warning: #fec526;   /* Reutilizamos el amarillo como advertencia */
            --color-success: #0f1d60;   /* Reutilizamos el azul oscuro como éxito */
            --color-info: #801250;      /* Reutilizamos el púrpura como info */
            --color-light: #ffffff;     /* Blanco */
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background-color: var(--color-light);
            color: var(--color-primary);
            padding: 20px;
        }
        
        .stat-card {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            height: 100%;
        }
        
        .stat-card h3 {
            margin-top: 0;
            color: var(--color-secondary);
            font-size: 1rem;
        }
        
        .stat-card .value {
            font-size: 2rem;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .stat-card .change {
            font-size: 0.8rem;
        }
        
        .positive {
            color: var(--color-success);
        }
        
        .negative {
            color: var(--color-accent);
        }
        
        .chart-card {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            height: 100%;
            margin-bottom: 20px;
        }
        
        .chart-card h2 {
            margin-top: 0;
            font-size: 1.2rem;
            color: var(--color-primary);
            border-bottom: 1px solid var(--color-light);
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        
        /* Filtro global */
        .global-date-filter {
            position: absolute;
            top: 20px;
            right: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .global-date-filter .btn {
            padding: 5px 12px;
            font-size: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 20px;
            transition: all 0.3s ease;
            background-color: white;
            color: var(--color-primary);
        }
        
        .global-date-filter .btn:hover {
            background-color: #f8f9fa;
        }
        
        .global-date-filter .btn.active {
            background-color: var(--color-secondary);
            color: white;
            border-color: var(--color-secondary);
            font-weight: 500;
        }
        
        .global-date-filter .btn.custom-range {
            background-color: var(--color-light);
            border-color: var(--color-secondary);
            color: var(--color-secondary);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .global-date-filter .btn.custom-range:hover {
            background-color: #e1f0fa;
        }
        
        .custom-range-container {
            position: relative;
            display: inline-block;
        }
        
        .custom-range-popup {
            position: absolute;
            background: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
            z-index: 100;
            display: none;
            width: 350px;
            right: 0;
            top: 100%;
            margin-top: 5px;
        }
        
        .custom-range-popup.show {
            display: block;
        }
        
        .custom-range-popup .header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .custom-range-popup .date-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        
        .custom-range-popup input {
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .custom-range-popup .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
        }
        
        .recent-activity {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .recent-activity h2 {
            margin-top: 0;
            font-size: 1.2rem;
            color: var(--color-primary);
            border-bottom: 1px solid var(--color-light);
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        
        .activity-item {
            padding: 10px 0;
            border-bottom: 1px solid var(--color-light);
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .page-header {
            position: relative;
            margin-bottom: 30px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-resuelto {
            background-color: var(--color-success);
            color: white;
        }
        
        .status-no-resuelto {
            background-color: var(--color-accent);
            color: white;
        }
        
        .status-espera {
            background-color: var(--color-warning);
            color: white;
        }
        
        .status-asignacion {
            background-color: var(--color-secondary);
            color: white;
        }
        
        .status-cancelado {
            background-color: var(--color-primary);
            color: white;
        }

        .change.positive {
            color: green;
        }

        .change.negative {
            color: red;
        }

        .change.neutral {
            color: gray;
        }


        .status-badge {
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
            color: #fff;
            text-transform: capitalize;
        }

        /* Estilos base para las tarjetas */
        .stat-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            height: 100%;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            border-left: 4px solid var(--color-primary); /* Línea lateral izquierda */
        }
    
        /* Efecto hover */
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
    
        /* Colores para las líneas laterales */
        .stat-card.card-total {
            border-left-color: var(--color-primary); /* Azul oscuro */
        }
    
        .stat-card.card-resueltos {
            border-left-color: var(--color-secondary); /* Vino/púrpura */
        }
    
        .stat-card.card-calificacion {
            border-left-color: var(--color-accent); /* Amarillo */
        }
    
        /* Estilos del contenido */
        .stat-card h3 {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 10px;
            font-weight: 600;
        }
    
        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-primary);
            margin-bottom: 8px;
        }
    
        /* Estilos para los cambios porcentuales */
        .stat-card .change {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
    
        .stat-card .change.positive {
            color: #28a745; /* Verde para positivos */
        }
    
        .stat-card .change.negative {
            color: #dc3545; /* Rojo para negativos */
        }
    
        .stat-card .change.neutral {
            color: #6c757d; /* Gris para neutros */
        }
    
        /* Efecto adicional al hacer hover */
        .stat-card:hover {
            border-left-width: 6px;
        }
    
        /* Pequeña animación para el valor */
        .stat-card .value {
            transition: transform 0.3s ease;
        }
    
        .stat-card:hover .value {
            transform: scale(1.05);
        }

        .chart-card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            border-left: 3px solid var(--color-primary);
        }
    
        .chart-title {
            color: var(--color-primary);
            font-size: 1.25rem;
            font-weight: 600;
        }
    
        .chart-description {
            font-size: 0.8rem;
        }
    
        .time-range-selector .btn {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
    
        .time-range-selector .btn.active {
            background-color: var(--color-primary);
            color: white;
            border-color: var(--color-primary);
        }

        .badge-tickets {
            background-color: #801250 !important;
            color: white; /* Asegura buen contraste */
        }

        /* Estilos para la tabla */
.table-header {
    background-color: #f8f9fa;
    color: #495057;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border-bottom: 2px solid #dee2e6;
}

.table-row {
    transition: all 0.2s ease;
    border-bottom: 1px solid #edf2f9;
}

.table-row:hover {
    background-color: #f8fafc;
}

/* Badges de estado */
.status-badge {
    font-size: 0.75rem;
    font-weight: 500;
    padding: 0.35rem 0.75rem;
}

.status-activo {
    background-color: rgba(78, 115, 223, 0.1);
    color: #4e73df;
}

.status-resuelto {
    background-color: rgba(28, 200, 138, 0.1);
    color: #1cc88a;
}

.status-pendiente {
    background-color: rgba(246, 194, 62, 0.1);
    color: #f6c23e;
}

.status-cancelado {
    background-color: rgba(231, 74, 59, 0.1);
    color: #e74a3b;
}

/* Estrellas de calificación */
.rating-stars {
    color: #f6c23e;
    font-size: 0.9rem;
}

/* Para el responsive */
@media (max-width: 768px) {
    .table-responsive {
        border: 0;
    }
    
    .table thead {
        display: none;
    }
    
    .table, .table tbody, .table tr, .table td {
        display: block;
        width: 100%;
    }
    
    .table tr {
        margin-bottom: 1rem;
        border: 1px solid #dee2e6;
        border-radius: 0.25rem;
    }
    
    .table td {
        text-align: right;
        padding-left: 50%;
        position: relative;
        border-bottom: 1px solid #dee2e6;
    }
    
    .table td::before {
        content: attr(data-label);
        position: absolute;
        left: 1rem;
        width: 45%;
        padding-right: 1rem;
        font-weight: 600;
        text-align: left;
        color: #495057;
    }
}


    </style>

</head>
<script>
    const idTotalTickets = '<%= litTotalTickets.ClientID %>';
    const idResolvedTickets = '<%= litResolvedTickets.ClientID %>';
    const idAvgRating = '<%= litAvgRating.ClientID %>';
</script>
<body>

        <div class="container-fluid">
            <!-- Header con filtro global -->
            <div class="page-header container">
                <!-- Primera fila: título -->
                <div class="row mb-3">
                    <div class="col">
                        <div class="profile-title">
                            <h1 class="mb-0">Panel de Control</h1>
                            <div id="TimeRange">
                                <span id="currentTimeRange" runat="server" class="text-muted small d-block mt-1"></span>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Segunda fila: filtros y botones -->
                <div class="row">
                    <div class="col">
                        <div class="global-date-filter d-flex flex-wrap gap-4 align-items-start">

                            <!-- Sección de filtros -->
                            <div class="d-flex flex-column">
                                <span class="fw-bold mb-2">Filtros</span>

                                <div class="d-flex flex-wrap gap-2 align-items-center">
                                    <!-- Botón que abre el modal -->
                                    <button type="button" class="btn btn-sm" data-bs-toggle="modal" data-bs-target="#customRangeModal">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                        Personalizado
                                    </button>

                                    <!-- Botones rápidos -->
                                    <asp:Button ID="btnToday" runat="server" Text="Hoy" CssClass="btn btn-sm custom-range" OnClick="btnDateFilter_Click" CommandArgument="hoy" />
                                    <asp:Button ID="btnThisWeek" runat="server" Text="Esta semana" CssClass="btn btn-sm custom-range" OnClick="btnDateFilter_Click" CommandArgument="semana" />
                                    <asp:Button ID="btnThisMonth" runat="server" Text="Este mes" CssClass="btn btn-sm custom-range" OnClick="btnDateFilter_Click" CommandArgument="mes" />
                                    <asp:Button ID="btnThisYear" runat="server" Text="Este año" CssClass="btn btn-sm custom-range" OnClick="btnDateFilter_Click" CommandArgument="año" />
                                </div>
                            </div>

                            <!-- Sección de exportación -->
                            <div class="d-flex flex-column">
                                <span class="fw-bold mb-2">Exportar</span>

                                <div class="d-flex flex-wrap gap-2 align-items-center">
                                    <asp:LinkButton ID="lnkExportPDF" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                        OnClientClick="exportAllChartsToPDF(); return false;">
                                        <i class="bi bi-file-earmark-pdf"></i> PDF
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkExportExcel" runat="server" CssClass="btn btn-sm btn-outline-success"
                                        OnClick="lnkExportExcel_Click"
                                        OnClientClick="alert('Generando archivo de click para aceptar y por favor espere...');">
                                        <i class="bi bi-file-earmark-excel"></i> Excel
                                    </asp:LinkButton>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>

            
            <div id="resumen-tarjetas" class="row mb-4 g-3">
                <!-- Tarjeta 1 - Tickets Totales -->
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card card-total">
                        <h3><i class="bi bi-ticket-detailed me-2"></i>Tickets totales</h3>
                        <div class="value"><asp:Literal ID="litTotalTickets" runat="server" Text="1,248"  ClientIDMode="Static"/></div>
                        <asp:Panel ID="panelTotalChange" runat="server" CssClass="change positive d-none">
                            <!--<asp:Literal ID="litTotalChange" runat="server" /> vs mes anterior-->
                        </asp:Panel>
                    </div>
                </div>
    
                <!-- Tarjeta 2 - Tickets Resueltos -->
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card card-resueltos">
                        <h3><i class="bi bi-check-circle me-2"></i>Tickets resueltos</h3>
                        <div class="value"><asp:Literal ID="litResolvedTickets" runat="server" Text="892"  ClientIDMode="Static"/></div>
                        <asp:Panel ID="panelResolvedChange" runat="server" CssClass="change positive d-none">
                            <!--<asp:Literal ID="litResolvedChange" runat="server" /> vs mes anterior-->
                        </asp:Panel>
                    </div>
                </div>
    
                <!-- Tarjeta 3 - Calificación Promedio -->
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card card-calificacion">
                        <h3><i class="bi bi-star-fill me-2"></i>Calificación promedio</h3>
                        <div class="value"><asp:Literal ID="litAvgRating" runat="server" Text="4.2/5"  ClientIDMode="Static"/></div>
                        <asp:Panel ID="panelRatingChange" runat="server" CssClass="change positive d-none">
                            <!--<asp:Literal ID="litRatingChange" runat="server" /> vs mes anterior-->
                        </asp:Panel>
                    </div>
                </div>
            </div>



            
            <!-- Charts Row 1 - Histórico y Estado -->
            <div class="row mb-4 g-3">
                <div class="col-lg-8">
                    <div class="chart-card shadow-sm">
                        <!-- Encabezado mejorado -->
                        <div class="chart-header d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="chart-title mb-1">Evolución de Tickets Creados</h3>
                                <p class="chart-description text-muted small mb-0">
                                    <i class="bi bi-info-circle"></i> 
                                    Muestra la cantidad de tickets creados según el período seleccionado. 
                                </p>
                            </div>
                        </div>
                        <!-- Gráfica -->
                        <div class="chart-container" style="position: relative; height:300px;">
                            <canvas id="ticketsByMonthChart"></canvas>
                        </div>
            
                        <!-- Leyenda interactiva -->
                        <div class="chart-legend mt-2 text-center">
                            <span class="badge badge-tickets me-2"><i class="bi bi-circle-fill"></i> Tickets creados</span>
                            <span class="badge bg-secondary"><i class="bi bi-circle-fill"></i> Límite promedio</span>
                        </div>
                    </div>
                </div>
    
                <div class="col-lg-4">
                    <div class="chart-card shadow-sm">
                        <div class="chart-header mb-3">
                            <h3 class="chart-title">Distribución por estado</h3>
                            <p class="chart-description text-muted small">
                                <i class="bi bi-info-circle"></i> 
                                Porcentaje de tickets según su estado actual
                            </p>
                        </div>
                        <div class="chart-container" style="position: relative; height:300px;">
                            <canvas id="ticketsStatusChart"></canvas>
                        </div>
                        <div class="chart-legend mt-2 text-center" id="statusLegend"></div>
                    </div>
                </div>
            </div>
            
            <!-- Charts Row 2 - Calificación y Área -->
            <div class="row mb-4 g-3">
                <div class="col-lg-6">
                    <div class="chart-card">
                        <h2>Calificación Promedio por Área</h2>
                        <p class="chart-description text-muted small mb-0">
                            <i class="bi bi-info-circle"></i> 
                            Muestra la evaluación promedio recibida por cada área
                        </p>
                        <canvas id="ratingByAreaChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="chart-card">
                        <h2>Tickets por Área remitente</h2>
                        <p class="chart-description text-muted small mb-0">
                            <i class="bi bi-info-circle"></i> 
                            Distribución de tickets según el área que los generó
                        </p>
                        <canvas id="ticketsByAreaChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Recent Activity -->
            <div class="row">
                <div class="col-12">
                    <div class="chart-card">
                        <h2>Tickets Recientes</h2>
                            <div class="table-responsive">
                                <asp:GridView ID="gvRecentTickets" runat="server" 
                                    CssClass="table table-hover align-middle" 
                                    AutoGenerateColumns="false"
                                    GridLines="None"
                                    HeaderStyle-CssClass="table-header"
                                    RowStyle-CssClass="table-row"
                                    EmptyDataText="No hay tickets recientes para mostrar">
                                    <Columns>
                                        <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-CssClass="fw-semibold" />
                                        <asp:BoundField DataField="Asunto" HeaderText="Asunto" ItemStyle-CssClass="text-truncate" ItemStyle-Width="30%" />
                                        <asp:BoundField DataField="Área" HeaderText="Área" ItemStyle-CssClass="text-capitalize" />
                                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" 
                                            DataFormatString="{0:dd/MM/yyyy HH:mm}" 
                                            ItemStyle-CssClass="text-nowrap" />
                                        <asp:TemplateField HeaderText="Estado" HeaderStyle-Width="120px">
                                            <ItemTemplate>
                                                <span class='badge status-badge status-<%# Eval("StatusClass") %> rounded-pill py-2 px-3'>
                                                    <i class="bi bi-circle-fill me-1"></i><%# Eval("Estado") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Calificación" ItemStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <div class="rating-stars">
                                                <%# GetRatingStars(Convert.ToInt32(Eval("Calificacion"))) %>
                                            </div>
                                        </ItemTemplate>
</asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                    </div>
                </div>
            </div>

                    <!-- Modal -->
            <div class="modal fade" id="customRangeModal" tabindex="-1" aria-labelledby="customRangeModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content border-0 shadow">
                        <!-- Encabezado con color primary -->
                      <div class="modal-header py-2 text-white" style="background-color: #801250; border-bottom: 2px solid var(--color-accent);">
                            <h6 class="modal-title mb-0" id="customRangeModalLabel">
                                <i class="bi bi-calendar-range me-2"></i>Seleccionar rango
                            </h6>
                            <button type="button" class="btn-close btn-close-white btn-sm" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>

                        <!-- Cuerpo del modal -->
                        <div class="modal-body py-3">
                            <div class="date-inputs d-flex flex-column gap-3">
                                <div>
                                    <label for="globalDateFrom" class="form-label mb-1 small fw-bold" style="color: var(--color-primary);">Desde</label>
                                    <asp:TextBox ID="globalDateFrom" runat="server" TextMode="Date" 
                                        CssClass="form-control form-control-sm border-primary" />
                                </div>

                                <div>
                                    <label for="globalDateTo" class="form-label mb-1 small fw-bold" style="color: var(--color-primary);">Hasta</label>
                                    <asp:TextBox ID="globalDateTo" runat="server" TextMode="Date" 
                                        CssClass="form-control form-control-sm border-primary" />
                                </div>
                            </div>
                        </div>

                        <!-- Pie del modal con acciones -->
                        <div class="modal-footer py-2 d-flex justify-content-between border-top-0">
                            <button type="button" class="btn btn-sm" 
                                    style="background-color: var(--color-light); color: var(--color-secondary); border: 1px solid var(--color-secondary);"
                                    data-bs-dismiss="modal" id="cancel-custom-range">
                                Cancelar
                            </button>
                            <asp:Button ID="btnApplyDateRange" runat="server" Text="Aplicar"
                                CssClass="btn btn-sm text-white" 
                                style="background-color: var(--color-secondary); border: 1px solid var(--color-secondary);"
                                OnClick="btnApplyDateRange_Click" />
                        </div>
                    </div>
                </div>
            </div>





        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
       <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <script>
        // Configuración común para gráficas
        Chart.defaults.font.family = 'Arial';
        Chart.defaults.font.size = 12;
        Chart.defaults.color = '#7f8c8d';

        // 1. Tickets por Área Remitente
        const ticketsByAreaCtx = document.getElementById('ticketsByAreaChart').getContext('2d');
        const ticketsByAreaChart = new Chart(ticketsByAreaCtx, {
            type: 'bar',
            data: {
                labels: <%= GetAreaLabels() %>,
                    datasets: [{
                        label: 'Tickets',
                        data: <%= GetAreaData() %>,
                        backgroundColor: [
                            '#fec526',  // Amarillo
                            '#0f1d60',  // Azul oscuro
                            '#801250',  // Vino
                            '#d6b6c8',  // Blanco
                            '#fec526',
                            '#0f1d60'
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return `${context.parsed.y} tickets`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        }
                    }
                }
            });

        // 2. Calificación Promedio por Área
        const ratingByAreaCtx = document.getElementById('ratingByAreaChart').getContext('2d');
        const ratingByAreaChart = new Chart(ratingByAreaCtx, {
            type: 'bar',
            data: {
                labels: <%= GetAreaLabelsScore() %>,
                    datasets: [{
                        label: 'Calificación',
                        data: <%= GetRatingData() %>,
                        backgroundColor: [
                            'rgba(254, 197, 38, 0.5)',  // Amarillo semitransparente
                            'rgba(15, 29, 96, 0.5)',    // Azul oscuro semitransparente
                            'rgba(128, 18, 80, 0.5)',   // Vino semitransparente
                            'rgba(214 182 200, 0.5)', // Blanco semitransparente
                            'rgba(254, 197, 38, 0.5)',
                            'rgba(15, 29, 96, 0.5)'
                        ],
                        borderColor: [
                            '#fec526',
                            '#0f1d60',
                            '#801250',
                            '#d6b6c8',
                            '#fec526',
                            '#0f1d60'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return `Calificación: ${context.parsed.y}/5`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 5,
                            ticks: {
                                stepSize: 0.5
                            }
                        }
                    }
                }
            });

        // 3. Estado de Tickets
        const ticketsStatusCtx = document.getElementById('ticketsStatusChart').getContext('2d');
        const ticketsStatusChart = new Chart(ticketsStatusCtx, {
            type: 'doughnut',
            data: {
                labels: <%= GetStatusLabels() %>,
                    datasets: [{
                        data: <%= GetStatusData() %>,
                        backgroundColor: [
                            '#fec526',
                            '#0f1d60',
                            '#801250',
                            '#d6b6c8',
                            '#fec526'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((context.parsed / total) * 100);
                                    return `${context.label}: ${context.parsed} (${percentage}%)`;
                                }
                            }
                        },
                        datalabels: {
                            display: false
                        }
                    },
                    cutout: '70%'
                },
                plugins: [ChartDataLabels]
            });

        // 4. Tickets por Mes (Histórico)
        const ticketsByMonthCtx = document.getElementById('ticketsByMonthChart').getContext('2d');
        const ticketsByMonthChart = new Chart(ticketsByMonthCtx, {
            type: 'line',
            data: {
                labels: <%= GetDynamicLabels() %>,
                    datasets: [{
                        label: 'Tickets',
                        data: <%= GetDynamicData() %>,
                        borderColor: '#801250',
                        backgroundColor: 'rgba(128, 18, 80, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return `${context.parsed.y} tickets`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        }
                    }
                }
            });

        // Funcionalidad para el filtro global de fecha
        const customRangeBtn = document.querySelector('.btn.custom-range');
        const customRangePopup = document.querySelector('.custom-range-popup');
        const cancelCustomRangeBtn = document.getElementById('cancel-custom-range');



        async function exportAllChartsToPDF() {
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF({
                orientation: "portrait",
                unit: "pt",
                format: "a4"
            });

            alert("Generando archivo. Haga clic en 'Aceptar' y por favor espere...");

            //let yOffset = 20;

            const timeRangeElement = document.getElementById("TimeRange");
            const timeRangeText = timeRangeElement ? timeRangeElement.innerText.trim() : "";


            pdf.setFontSize(12);
            pdf.setTextColor(100);
            pdf.text(`Período seleccionado: ${timeRangeText}`, 40, 30); // (x: 40, y: 30)

            let yOffset = 50;

            // 📌 1. CAPTURAR TARJETAS
            const resumenElement = document.getElementById("resumen-tarjetas");

            // Asegúrate de que no tenga clases ocultas (como d-none)
            resumenElement.querySelectorAll(".d-none").forEach(el => el.classList.remove("d-none"));

            const resumenCanvas = await html2canvas(resumenElement, {
                scale: 4,
                useCORS: true
            });

            const resumenImg = resumenCanvas.toDataURL("image/png");
            const canvasWidth = resumenCanvas.width;
            const canvasHeight = resumenCanvas.height;
            const imgWidth = 500;
            const imgHeight = (canvasHeight / canvasWidth) * imgWidth;


            pdf.setFontSize(16);
            pdf.text("Resumen general del sistema", 40, yOffset + 15);
            pdf.addImage(resumenImg, "PNG", 40, yOffset + 30, imgWidth, imgHeight);
            yOffset += imgHeight + 50; // deja 20px de espacio  Espacio después de las tarjetas

            if (yOffset > pdf.internal.pageSize.getHeight() - 100) {
                // Imprimir número en la página actual antes de crear una nueva
                const pageNum = pdf.getNumberOfPages();
                pdf.setFontSize(10);
                pdf.text(`Página ${pageNum}`, 500, pdf.internal.pageSize.getHeight() - 20);

                pdf.addPage();
                yOffset = 20;
            }


            const chartCanvases = [
                {
                    id: "ticketsByMonthChart",
                    title: "Tickets por mes",
                    descripcion: "Muestra la cantidad de tickets creados según el período seleccionado."
                },
                {
                    id: "ticketsStatusChart",
                    title: "Estado de los tickets",
                    descripcion: "Distribución porcentual de los tickets según su estado actual y el período seleccionado."
                },
                {
                    id: "ratingByAreaChart",
                    title: "Calificación promedio",
                    descripcion: "Evaluación promedio de cada área, basada en encuestas de satisfacción."
                },
                {
                    id: "ticketsByAreaChart",
                    title: "Tickets por área",
                    descripcion: "Cantidad de tickets generados por cada área operativa."
                }

            ];

            

            for (const chart of chartCanvases) {
                const chartInstance = Chart.getChart(chart.id);
                if (!chartInstance) continue;

                const imgData = createHighResChartImage(chartInstance);

                // 📌 Dimensiones
                let imgWidth = 500;
                let imgHeight = 250;

                if (chart.id === "ticketsStatusChart") {
                    imgWidth = 300;
                    imgHeight = 300;
                }

                // Si no cabe en la página actual, crea una nueva
                if (yOffset + imgHeight > pdf.internal.pageSize.getHeight()) {
                    pdf.addPage();
                    yOffset = 20;
                }

                // Titulo
                pdf.setFontSize(14);
                pdf.text(chart.title, 40, yOffset + 15);

                // Agregar descripción si existe
                if (chart.descripcion) {
                    pdf.setFontSize(10);
                    const splitText = pdf.splitTextToSize(chart.descripcion, 500); // envuelve texto largo
                    pdf.text(splitText, 40, yOffset + 30);
                    // Calcular espacio total ocupado por descripción
                    const descripcionHeight = 15 * splitText.length;

                    // Aquí das un margen extra debajo de la descripción antes de la imagen
                    const marginBottom = 20;

                    yOffset += descripcionHeight + marginBottom;
                } else {
                    // Si no hay descripción, dejar un espacio base
                    yOffset += 20;
                } 

                // 📌 Dibujo especial para ticketsStatusChart
                if (chart.id === "ticketsStatusChart") {
                    // Imagen
                    pdf.addImage(imgData, "PNG", 40, yOffset, imgWidth, imgHeight);

                    // Márgenes personalizados
                    const tableMarginLeft = 140;  // margen adicional izquierdo
                    const tableMarginTop = 90;   // margen adicional superior

                    // Tabla al lado derecho
                    const tableX = 260 + tableMarginLeft;
                    let tableY = yOffset + tableMarginTop;

                    pdf.setFontSize(10);
                    pdf.text("Estados de tickets", tableX, tableY);
                    tableY += 15;

                    // Construir tabla dinámicamente
                    const statusLabels = <%= GetStatusLabels() %>;
                    const statusData = <%= GetStatusData() %>;

                    const tableData = statusLabels.map((label, i) => [label, `${statusData[i]}%`]);

                    for (const [estado, valor] of tableData) {
                        pdf.text(estado, tableX, tableY);
                        pdf.text(valor, tableX + 80, tableY);
                        tableY += 15;
                    }


                    yOffset += imgHeight + 40;
                } else {
                    // Imagen normal
                    pdf.addImage(imgData, "PNG", 40, yOffset, imgWidth, imgHeight);
                    yOffset += imgHeight + 40;
                }

            }

            pdf.save("graficas.pdf");
        }

        function createHighResChartImage(chart, scale = 2) {
            const origCanvas = chart.canvas;
            const width = origCanvas.width;
            const height = origCanvas.height;

            const tmpCanvas = document.createElement("canvas");
            tmpCanvas.width = width * scale;
            tmpCanvas.height = height * scale;

            const tmpCtx = tmpCanvas.getContext("2d");
            tmpCtx.scale(scale, scale);

            // Copia la imagen del canvas original al nuevo con escala
            tmpCtx.drawImage(origCanvas, 0, 0);

            return tmpCanvas.toDataURL("image/png");
        }


    </script>
    
</body>
</asp:Content>
