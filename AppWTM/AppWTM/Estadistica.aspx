<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Estadistica.aspx.cs" Inherits="AppWTM.Estadistica" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gráfico de Tickets por Área</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        #ticketsChart {
            max-width: 300px;
            max-height: 150px;
            width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
    <h1>Gráfico de Tickets por Área</h1>
    <!-- Contenedor para la gráfica -->
    <canvas id="ticketsChart" width="400" height="200"></canvas>

    <!-- Contenedor para insertar el JSON -->
    <asp:Literal ID="jsonContainer" runat="server"></asp:Literal>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        window.onload = function () {
            // Cargar los datos y crear el gráfico
            if (typeof datos === 'undefined' || datos.length === 0) {
                alert("No hay datos disponibles para mostrar.");
                return;
            }

            var areas = datos.map(item => item.Dep_Nombre);
            var cantidadTickets = datos.map(item => item.Total_Tickets);

            var ctx = document.getElementById('ticketsChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: areas,
                    datasets: [{
                        label: 'Cantidad de Tickets',
                        data: cantidadTickets,
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        };
    </script>
</body>

</html>
