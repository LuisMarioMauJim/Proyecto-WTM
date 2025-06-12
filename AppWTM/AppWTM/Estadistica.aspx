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

    </style>
</head>
<body>

        <div class="container-fluid">
            <!-- Header con filtro global -->
            <div class="page-header container">
                <!-- Primera fila: título -->
                <div class="row mb-3">
                    <div class="col">
                        <h1 class="mb-0">Panel de Control</h1>
                    </div>
                </div>

                <!-- Segunda fila: filtros y botones -->
                <div class="row">
                    <div class="col">
                        <div class="global-date-filter d-flex flex-wrap gap-2 align-items-center">
                            <div class="custom-range-container position-relative">
                                <button class="btn btn-sm custom-range d-none" type="button">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    Personalizado
                                </button>
                                <div class="custom-range-popup">
                                    <div class="header">
                                        <h3>Seleccionar rango</h3>
                                    </div>
                                    <div class="date-inputs">
                                        <div>
                                            <label>Desde</label>
                                            <asp:TextBox ID="globalDateFrom" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div>
                                            <label>Hasta</label>
                                            <asp:TextBox ID="globalDateTo" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="actions mt-2">
                                        <button class="btn btn-sm" id="cancel-custom-range" type="button">Cancelar</button>
                                        <asp:Button ID="btnApplyDateRange" runat="server" Text="Aplicar" CssClass="btn btn-sm active" OnClick="btnApplyDateRange_Click" />
                                    </div>
                                </div>
                            </div>

                            <!-- Botones rápidos -->
                            <asp:Button ID="btnToday" runat="server" Text="Hoy" CssClass="btn btn-sm custom-range"  OnClick="btnDateFilter_Click" CommandArgument="hoy" />
                            <asp:Button ID="btnThisWeek" runat="server" Text="Esta semana" CssClass="btn btn-sm custom-range"  OnClick="btnDateFilter_Click" CommandArgument="semana" />
                            <asp:Button ID="btnThisMonth" runat="server" Text="Este mes" CssClass="btn btn-sm custom-range"  OnClick="btnDateFilter_Click" CommandArgument="mes" />
                            <asp:Button ID="btnThisYear" runat="server" Text="Este año" CssClass="btn btn-sm custom-range"  OnClick="btnDateFilter_Click" CommandArgument="año" />

                            <!-- Exportar -->
                            <!-- Botones de exportación -->
                            <asp:LinkButton ID="lnkExportPDF" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="exportAllChartsToPDF(); return false;">
                                <i class="bi bi-file-earmark-pdf"></i> PDF
                            </asp:LinkButton>

                            <asp:LinkButton ID="lnkExportExcel" runat="server" CssClass="btn btn-sm btn-outline-success"
                                OnClick="lnkExportExcel_Click">
                                <i class="bi bi-file-earmark-excel"></i> Excel
                            </asp:LinkButton>


                        </div>
                    </div>
                </div>
            </div>

            
            <!-- Stats Cards -->
            <div class="row mb-4 g-3">
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card">
                        <h3>Tickets Totales</h3>
                        <div class="value"><asp:Literal ID="litTotalTickets" runat="server" Text="1,248" /></div>
                        <asp:Panel ID="panelTotalChange" runat="server" CssClass="change positive d-none">
                            <asp:Literal ID="litTotalChange" runat="server" /> vs mes anterior
                        </asp:Panel>
                    </div>
                </div>
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card">
                        <h3>Tickets Resueltos</h3>
                        <div class="value"><asp:Literal ID="litResolvedTickets" runat="server" Text="892" /></div>
                        <asp:Panel ID="panelResolvedChange" runat="server" CssClass="change positive d-none">
                            <asp:Literal ID="litResolvedChange" runat="server" /> vs mes anterior
                        </asp:Panel>
                    </div>
                </div>
                <div class="col-md-4 col-sm-6">
                    <div class="stat-card">
                        <h3>Calificación Promedio</h3>
                        <div class="value"><asp:Literal ID="litAvgRating" runat="server" Text="4.2/5" /></div>
                        <asp:Panel ID="panelRatingChange" runat="server" CssClass="change positive d-none">
                            <asp:Literal ID="litRatingChange" runat="server" /> vs mes anterior
                        </asp:Panel>
                    </div>
                </div>
            </div>



            
            <!-- Charts Row 1 - Histórico y Estado -->
            <div class="row mb-4 g-3">
                <div class="col-lg-8">
                    <div class="chart-card">
                        <h2>Creacion de Tickets</h2>
                        <canvas id="ticketsByMonthChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="chart-card">
                        <h2>Estado de Tickets</h2>
                        <canvas id="ticketsStatusChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Charts Row 2 - Calificación y Área -->
            <div class="row mb-4 g-3">
                <div class="col-lg-6">
                    <div class="chart-card">
                        <h2>Calificación Promedio por Área</h2>
                        <canvas id="ratingByAreaChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="chart-card">
                        <h2>Tickets por Área Remitente</h2>
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
                            <asp:GridView ID="gvRecentTickets" runat="server" CssClass="table" AutoGenerateColumns="false">
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="ID" />
                                    <asp:BoundField DataField="Asunto" HeaderText="Asunto" />
                                    <asp:BoundField DataField="Area" HeaderText="Área" />
                                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:TemplateField HeaderText="Estado">
                                        <ItemTemplate>
                                            <span class='status-badge status-<%# Eval("StatusClass") %>'><%# Eval("Estado") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Calificacion" HeaderText="Calificación" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
       <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
 
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
                            'rgba(255, 255, 255, 0.5)', // Blanco semitransparente
                            'rgba(254, 197, 38, 0.5)',
                            'rgba(15, 29, 96, 0.5)'
                        ],
                        borderColor: [
                            '#fec526',
                            '#0f1d60',
                            '#801250',
                            '#ffffff',
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
                            '#ffffff',
                            '#fec526'
                        ],
                        borderWidth: 0
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

        // Mostrar/ocultar popup de rango personalizado
        customRangeBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            customRangePopup.classList.toggle('show');
        });

        // Cancelar rango personalizado
        cancelCustomRangeBtn.addEventListener('click', function () {
            customRangePopup.classList.remove('show');
        });

        // Cerrar popup al hacer clic fuera
        document.addEventListener('click', function () {
            customRangePopup.classList.remove('show');
        });

        // Evitar que el clic en el popup lo cierre
        customRangePopup.addEventListener('click', function (e) {
            e.stopPropagation();
        });

        document.addEventListener("DOMContentLoaded", function () {
            const dropdownToggle = document.getElementById("exportDropdown");
            const dropdownMenu = dropdownToggle.nextElementSibling;

            dropdownToggle.addEventListener("click", function (e) {
                e.preventDefault();
                dropdownMenu.classList.toggle("show");
            });

            document.addEventListener("click", function (e) {
                if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove("show");
                }
            });
        });


        async function exportAllChartsToPDF() {
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF({
                orientation: "portrait",
                unit: "pt",
                format: "a4"
            });

            // Encuentra todos los canvas de gráficos
            const chartCanvases = [
                { id: "ticketsByAreaChart", title: "Tickets por Área" },
                { id: "ratingByAreaChart", title: "Calificación Promedio" },
                { id: "ticketsStatusChart", title: "Estado de Tickets" },
                { id: "ticketsByMonthChart", title: "Tickets por Mes" }
            ];

            let yOffset = 20;

            for (const chart of chartCanvases) {
                const canvas = document.getElementById(chart.id);
                if (!canvas) continue;

                const imgData = canvas.toDataURL("image/png", 1.0);
                pdf.setFontSize(14);
                pdf.text(chart.title, 40, yOffset + 15);
                pdf.addImage(imgData, "PNG", 40, yOffset + 30, 500, 250);
                yOffset += 300;

                // Si se pasa del alto de la página, crea una nueva
                if (yOffset + 250 > pdf.internal.pageSize.getHeight()) {
                    pdf.addPage();
                    yOffset = 20;
                }
            }

            pdf.save("graficas.pdf");
        }




    </script>
    
</body>
</asp:Content>
