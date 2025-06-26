<%@ Page Title="Nuevo Evento" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NuevoEvento.aspx.cs" Inherits="AppWTM.NuevoEvento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
       .calendar-container {
    max-width: 1000px;
    margin: auto;
    padding: 30px;
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(15, 29, 96, 0.1);
}

.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding: 20px;
    background: linear-gradient(135deg, #0f1d60 0%, #801250 100%);
    border-radius: 12px;
    color: #ffffff;
}

.calendar-title {
    font-size: 28px;
    font-weight: bold;
    color: #ffffff;
    margin: 0;
}

.calendar-navigation {
    display: flex;
    align-items: center;
    gap: 20px;
}

.nav-button {
    color: #0f1d60;
    border: none;
    padding: 10px 15px;
    border-radius: 50%;
    cursor: pointer;
    font-size: 16px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    font-weight: bold;
}

.nav-button:hover {
    background-color: #e6b022;
    transform: scale(1.1);
    box-shadow: 0 4px 8px rgba(254, 197, 38, 0.3);
}

.btn-agregar-evento {
    background-color: #fec526;
    color: #0f1d60;
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    font-size: 16px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-agregar-evento:hover {
    background-color: #e6b022;
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(254, 197, 38, 0.3);
}

.calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 10px;
}

.calendar-cell {
    border: 2px solid #f0f0f0;
    border-radius: 10px;
    min-height: 100px;
    padding: 8px;
    position: relative;
    cursor: pointer;
    transition: all 0.3s ease;
    background-color: #ffffff;
}

.calendar-cell:hover {
  /*background-color: #fec526;*/
    border-color: #0f1d60;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(15, 29, 96, 0.1);
}

.day-number {
    font-weight: bold;
    margin-bottom: 5px;
    color: #0f1d60;
    font-size: 16px;
}

.event-badge {
    display: block;
    padding: 4px 8px;
    margin-top: 4px;
    border-radius: 6px;
    font-size: 12px;
    color: #ffffff;
    background-color: #801250;
    font-weight: 500;
    border-left: 3px solid #fec526;
}

/* Formulario en dos columnas */
.form-container {
    max-width: 680px;
    margin: auto;
    padding: 30px;
    border: 2px solid #0f1d60;
    border-radius: 15px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
    box-shadow: 0 8px 25px rgba(15, 29, 96, 0.15);
}

.form-title {
    font-size: 28px;
    margin-bottom: 30px;
    color: #0f1d60;
    text-align: center;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    position: relative;
}

.form-title::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 3px;
    background-color: #fec526;
    border-radius: 2px;
}

/* Grid de dos columnas para el formulario */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-control {
    width: 100%;
    padding: 12px 16px;
    margin-bottom: 16px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.3s ease;
}

.form-control:focus {
    outline: none;
    border-color: #fec526;
    box-shadow: 0 0 0 3px rgba(254, 197, 38, 0.1);
    background-color: #fffef8;
}

.form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #0f1d60;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.form-check {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.form-check input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: #fec526;
}

.form-check label {
    color: #0f1d60;
    font-weight: 500;
    cursor: pointer;
}

.btn-guardar {
    background: linear-gradient(135deg, #0f1d60 0%, #1a2b7a 100%);
    color: #ffffff;
    border: none;
    padding: 14px 28px;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
    font-size: 16px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-guardar:hover {
    background: linear-gradient(135deg, #1a2b7a 0%, #0f1d60 100%);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(15, 29, 96, 0.3);
}

.btn-cancelar {
    background: linear-gradient(135deg, #801250 0%, #a01560 100%);
    color: #ffffff;
    border: none;
    padding: 14px 28px;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
    font-size: 14px;
    margin-left: 15px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-cancelar:hover {
    background: linear-gradient(135deg, #a01560 0%, #801250 100%);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(128, 18, 80, 0.3);
}

.btn-group {
    text-align: center;
    margin-top: 10px;
    padding-top: 5px;
    border-top: 2px solid #f0f0f0;
}

/* Modal styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(15, 29, 96, 0.8);
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(5px);
}

.modal.show {
    display: flex;
}

.modal .form-container {
    margin: 0;
    max-height: 90vh;
    overflow-y: auto;
    animation: modalSlideIn 0.3s ease;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-50px) scale(0.9);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.day-header {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 10px;
    margin-bottom: 15px;
    font-weight: bold;
    text-align: center;
    padding: 15px 0;
    border-bottom: 3px solid #fec526;
    background: linear-gradient(135deg, #0f1d60 0%, #801250 100%);
    border-radius: 10px 10px 0 0;
}

.day-name {
    color: #ffffff;
    font-size: 14px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 1px;
}

/* Responsive para dispositivos móviles */
@media (max-width: 768px) {
    .form-grid {
        grid-template-columns: 1fr;
        gap: 15px;
    }
    
    .calendar-header {
        flex-direction: column;
        gap: 20px;
        text-align: center;
    }
    
    .calendar-navigation {
        order: 2;
    }
    
    .form-container {
        padding: 20px;
        margin: 10px;
    }
    
    .btn-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    
    .btn-cancelar {
        margin-left: 0;
    }
}

/* Efectos adicionales */
.calendar-container {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
    border: 2px solid #fec526;
}

.text-danger {
    color: #801250;
    font-weight: 500;
    margin-bottom: 15px;
    padding: 10px;
    background-color: rgba(128, 18, 80, 0.1);
    border-radius: 5px;
    border-left: 4px solid #801250;
}
.calendar-cell.hoy {
            background-color: #f8f865 !important;
            border: none !important;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
        }
    </style>

    <div class="calendar-container">
        <div class="calendar-header">
            <div class="calendar-navigation">
                <button class="nav-button" onclick="cambiarMes(-1)" title="Mes anterior">‹</button>
                <h2 class="calendar-title" id="tituloMes"></h2>
                <button class="nav-button" onclick="cambiarMes(1)" title="Mes siguiente">›</button>
            </div>
            <button class="btn-agregar-evento" onclick="abrirModalAgregar()">Agregar Evento</button>
        </div>
        
        <!-- Encabezados de días -->
        <div class="day-header">
            <div class="day-name">Lun</div>
            <div class="day-name">Mar</div>
            <div class="day-name">Mié</div>
            <div class="day-name">Jue</div>
            <div class="day-name">Vie</div>
            <div class="day-name">Sáb</div>
            <div class="day-name">Dom</div>
        </div>
        
        <asp:Literal ID="litCalendario" runat="server"></asp:Literal>
    </div>

   <!-- Modal para Agregar Evento -->
<div id="modalAgregarEvento" class="modal">
    <div class="form-container">
        <h2 class="form-title">Agregar Nuevo Evento</h2>

        <asp:ValidationSummary runat="server" CssClass="text-danger" />

        <div class="form-grid">
            <div class="form-group">
                <label for="txtTitulo" class="form-label">Título del evento</label>
                <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control" placeholder="Título del evento" required></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtColor" class="form-label">Color del evento</label>
                <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" Text="#fec526" TextMode="Color" />
            </div>

            <div class="form-group">
                <label for="txtInicio" class="form-label">Fecha y hora de inicio</label>
                <asp:TextBox ID="txtInicio" runat="server" TextMode="DateTimeLocal" CssClass="form-control" required></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtFin" class="form-label">Fecha y hora de fin</label>
                <asp:TextBox ID="txtFin" runat="server" TextMode="DateTimeLocal" CssClass="form-control" required></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtDescripcion" class="form-label">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Descripción del evento..."></asp:TextBox>
            </div>

            <div class="form-group">
                <div class="form-check">
                    <asp:CheckBox ID="chkTodoDia" runat="server" Text=" Todo el día" />
                </div>
            </div>
        </div>

        <div class="btn-group">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Evento" CssClass="btn-guardar" OnClick="btnGuardar_Click" />
            <button type="button" class="btn-cancelar" onclick="cerrarModalAgregar()">Cancelar</button>
        </div>
    </div>
</div>

<!-- Modal para Editar Evento -->
<div id="modalEditarEvento" class="modal">
    <div class="form-container">
        <h2 class="form-title">Editar Evento</h2>

        <div class="form-grid">
            <div class="form-group">
                <label class="form-label">Título del evento</label>
                <input type="text" id="editTitulo" class="form-control" placeholder="Título del evento" />
            </div>

            <div class="form-group">
                <label class="form-label">Color del evento</label>
                <input type="color" id="editColor" class="form-control" />
            </div>

            <div class="form-group">
                <label class="form-label">Fecha y hora de inicio</label>
                <input type="datetime-local" id="editInicio" class="form-control" />
            </div>

            <div class="form-group">
                <label class="form-label">Fecha y hora de fin</label>
                <input type="datetime-local" id="editFin" class="form-control" />
            </div>

            <div class="form-group">
                <label class="form-label">Descripción</label>
                <textarea id="editDescripcion" class="form-control" rows="4" placeholder="Descripción del evento..."></textarea>
            </div>

            <div class="form-group">
                <div class="form-check">
                    <input type="checkbox" id="editTodoDia" /> 
                    <label for="editTodoDia">Todo el día</label>
                </div>
            </div>
        </div>

        <div class="btn-group">
            <button onclick="guardarCambiosEvento()" class="btn-guardar">Guardar Cambios</button>
            <button onclick="cerrarModalEditar()" class="btn-cancelar">Cancelar</button>
        </div>
            <input type="hidden" id="editIdEvento" />
        </div>
    </div>
    <script type="text/javascript">
        const usuarioId = <%= ObtenerUsuarioId() %>;
  const departamentoId = <%= ObtenerDepartamentoId() %>;
    </script>

<script>
     
    let mesActual = new Date().getMonth();
    let añoActual = new Date().getFullYear();

    // Inicializar el calendario al cargar la página
    document.addEventListener('DOMContentLoaded', function () {
        // Leer parámetros de la URL si existen
        const urlParams = new URLSearchParams(window.location.search);
        const mesParam = urlParams.get('mes');
        const añoParam = urlParams.get('año');

        if (mesParam !== null && añoParam !== null) {
            mesActual = parseInt(mesParam);
            añoActual = parseInt(añoParam);
        }

        actualizarTituloMes();
    });

    function actualizarTituloMes() {
        const meses = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];

        const elemento = document.getElementById('tituloMes');
        if (elemento) {
            elemento.textContent = `${meses[mesActual]} ${añoActual}`;
        }
    }

    function cambiarMes(direccion) {
        mesActual += direccion;

        if (mesActual > 11) {
            mesActual = 0;
            añoActual++;
        } else if (mesActual < 0) {
            mesActual = 11;
            añoActual--;
        }

        actualizarTituloMes();

        // Mostrar indicador de carga
     //   Swal.fire({
       //     title: 'Cargando...',
         //   text: 'Actualizando calendario',
           // allowOutsideClick: false,
            //showConfirmButton: false,
            //willOpen: () => {
              //  Swal.showLoading();
           // }
        //});

        // Redirigir con los nuevos parámetros
        window.location.href = `NuevoEvento.aspx?mes=${mesActual}&año=${añoActual}`;
    }

    function abrirModalAgregar() {
        // Limpiar el formulario
        document.getElementById('<%= txtTitulo.ClientID %>').value = '';
        document.getElementById('<%= txtDescripcion.ClientID %>').value = '';
        document.getElementById('<%= txtInicio.ClientID %>').value = '';
        document.getElementById('<%= txtFin.ClientID %>').value = '';
        document.getElementById('<%= chkTodoDia.ClientID %>').checked = false;
        document.getElementById('<%= txtColor.ClientID %>').value = '#007bff';

        document.getElementById('modalAgregarEvento').classList.add('show');
    }

    function cerrarModalAgregar() {
        document.getElementById('modalAgregarEvento').classList.remove('show');
    }

    function parseDotNetDate(dotNetDateStr) {
        const match = /\/Date\((\d+)(?:-\d+)?\)\//.exec(dotNetDateStr);
        if (match) {
            const milliseconds = parseInt(match[1], 10);
            return new Date(milliseconds);
        }
        return new Date(NaN);
    }

    function convertirFechaHTML(dotNetDate) {
        const date = parseDotNetDate(dotNetDate);
        const pad = n => n.toString().padStart(2, '0');
        return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
    }

    function mostrarEventosDelDia(fecha) {
        fetch('/ServiciosCalendario.asmx/GetEventosPorFecha', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=utf-8' },
            body: JSON.stringify({ fecha: fecha })
        })
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                let eventos = [];
                try {
                    eventos = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
                } catch (e) {
                    console.error("Error al parsear JSON:", e);
                    throw new Error("Formato de datos no válido");
                }

                if (eventos.length > 0) {
                    let contenido = '<ul style="text-align: left;">';
                    eventos.forEach(e => {
                        const fechaInicio = parseDotNetDate(e.Fecha_Inicio).toLocaleString('es-MX');
                        const fechaFin = parseDotNetDate(e.Fecha_Fin).toLocaleString('es-MX');

                        contenido += `<li style="margin-bottom: 10px;">
                        <strong>${e.Evento_Titulo || 'Sin título'}</strong><br/>
                        <span style="color: #666;">${e.Evento_Descripcion || 'Sin descripción'}</span><br/>
                        <small>Inicio: ${fechaInicio}</small><br/>
                        <small>Fin: ${fechaFin}</small><br/>
                        <div style="margin-top: 8px;">
                            <button onclick="editarEvento(${e.Id_Evento})" style="margin-right: 5px; padding: 4px 8px; background: #007bff; color: white; border: none; border-radius: 4px;">Editar</button>
                            <button onclick="eliminarEvento(${e.Id_Evento})" style="padding: 4px 8px; background: #dc3545; color: white; border: none; border-radius: 4px;">Eliminar</button>
                        </div>
                    </li>`;
                    });
                    contenido += '</ul>';

                    Swal.fire({
                        title: 'Eventos del ' + new Date(fecha).toLocaleDateString('es-MX'),
                        html: contenido,
                        width: '600px',
                        confirmButtonText: 'Cerrar'
                    });
                } else {
                    Swal.fire({
                        title: 'Sin eventos',
                        text: 'No hay eventos para este día',
                        icon: 'info',
                        confirmButtonText: 'OK'
                    });
                }
            })
            .catch(error => {
                console.error('Error al cargar eventos:', error);
                Swal.fire({
                    title: 'Error',
                    text: 'No se pudieron cargar los eventos. Detalle: ' + error.message,
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            });
    }

    function editarEvento(id) {
        fetch('/ServiciosCalendario.asmx/GetEventoPorId', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=utf-8' },
            body: JSON.stringify({ id: id })
        })
            .then(r => r.json())
            .then(data => {
                const evento = typeof data.d === "string" ? JSON.parse(data.d) : data.d;

                if (!evento) {
                    Swal.fire("Error", "No se encontró el evento para editar.", "error");
                    return;
                }

                Swal.close();

                document.getElementById('editTitulo').value = evento.Evento_Titulo;
                document.getElementById('editDescripcion').value = evento.Evento_Descripcion;
                document.getElementById('editInicio').value = convertirFechaHTML(evento.Fecha_Inicio);
                document.getElementById('editFin').value = convertirFechaHTML(evento.Fecha_Fin);
                document.getElementById('editTodoDia').checked = evento.Todo_El_Dia;
                document.getElementById('editColor').value = evento.Color;
                document.getElementById('editIdEvento').value = evento.Id_Evento;

                document.getElementById('modalEditarEvento').classList.add('show');
            })
            .catch(error => {
                console.error("Error al cargar evento:", error);
                Swal.fire("Error", "No se pudo cargar el evento para editar.", "error");
            });
    }

    function cerrarModalEditar() {
        document.getElementById('modalEditarEvento').classList.remove('show');
    }

    function guardarCambiosEvento() {
        console.log("=== INICIO guardarCambiosEvento ===");

        try {
            // Recopilar datos del formulario
            const evento = {
                Id_Evento: parseInt(document.getElementById('editIdEvento').value),
                Evento_Titulo: document.getElementById('editTitulo').value?.trim() || "",
                Evento_Descripcion: document.getElementById('editDescripcion').value?.trim() || "",
                Fecha_Inicio: document.getElementById('editInicio').value,
                Fecha_Fin: document.getElementById('editFin').value,
                Todo_El_Dia: document.getElementById('editTodoDia').checked,
                Color: document.getElementById('editColor').value || "#007bff",
                fk_Usuario: usuarioId,
                fk_Departamento: departamentoId
            };

            // Log de datos antes de enviar
            console.log("Datos del evento a enviar:", evento);

            // Validaciones del lado cliente
            if (!evento.Id_Evento || evento.Id_Evento <= 0) {
                Swal.fire("Error", "ID del evento inválido", "error");
                return;
            }

            if (!evento.Evento_Titulo) {
                Swal.fire("Error", "El título del evento es obligatorio", "error");
                return;
            }

            if (!evento.Fecha_Inicio || !evento.Fecha_Fin) {
                Swal.fire("Error", "Las fechas de inicio y fin son obligatorias", "error");
                return;
            }

            // Validar fechas
            const fechaInicio = new Date(evento.Fecha_Inicio);
            const fechaFin = new Date(evento.Fecha_Fin);

            if (fechaInicio > fechaFin) {
                Swal.fire("Error", "La fecha de inicio no puede ser posterior a la fecha de fin", "error");
                return;
            }

            // Mostrar indicador de carga
            Swal.fire({
                title: 'Guardando...',
                text: 'Actualizando evento',
                allowOutsideClick: false,
                showConfirmButton: false,
                willOpen: () => {
                    Swal.showLoading();
                }
            });

            // Preparar datos para envío
            const datosEnvio = {
                ev: JSON.stringify(evento)
            };

            console.log("Datos JSON a enviar:", datosEnvio);

            // Realizar petición
            fetch('/ServiciosCalendario.asmx/ActualizarEvento', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(datosEnvio)
            })
                .then(response => {
                    console.log("Status de respuesta:", response.status);
                    console.log("Headers de respuesta:", response.headers);

                    if (!response.ok) {
                        throw new Error(`Error HTTP: ${response.status} - ${response.statusText}`);
                    }

                    return response.text(); // Primero como texto para debug
                })
                .then(responseText => {
                    console.log("Respuesta del servidor (texto):", responseText);

                    // Intentar parsear como JSON
                    let data;
                    try {
                        data = JSON.parse(responseText);
                    } catch (parseError) {
                        console.error("Error parsing JSON:", parseError);
                        throw new Error("Respuesta del servidor no es JSON válido");
                    }

                    console.log("Respuesta del servidor (parseada):", data);

                    // Extraer resultado (puede venir en data.d o directamente en data)
                    let resultado = data.d || data;

                    // Si resultado es string, intentar parsearlo
                    if (typeof resultado === "string") {
                        try {
                            resultado = JSON.parse(resultado);
                        } catch (e) {
                            console.error("Error parsing resultado interno:", e);
                            throw new Error("Formato de respuesta no válido");
                        }
                    }

                    console.log("Resultado final:", resultado);

                    // Cerrar modal de carga
                    Swal.close();

                    if (resultado.success) {
                        // Cerrar modal de edición
                        cerrarModalEditar();

                        // Mostrar éxito y recargar
                        Swal.fire({
                            title: "¡Actualizado!",
                            text: resultado.message || "Evento actualizado correctamente",
                            icon: "success",
                            confirmButtonText: "OK"
                        }).then(() => {
                            // Recargar página manteniendo mes/año actual
                            window.location.href = `NuevoEvento.aspx?mes=${mesActual}&año=${añoActual}`;
                        });
                    } else {
                        Swal.fire({
                            title: "Error",
                            text: resultado.message || "No se pudo actualizar el evento",
                            icon: "error",
                            confirmButtonText: "OK"
                        });
                    }
                })
                .catch(error => {
                    console.error("Error en fetch:", error);

                    // Cerrar modal de carga si está abierto
                    Swal.close();

                    Swal.fire({
                        title: "Error de conexión",
                        text: `No se pudo conectar con el servidor: ${error.message}`,
                        icon: "error",
                        confirmButtonText: "OK"
                    });
                });

        } catch (error) {
            console.error("Error en guardarCambiosEvento:", error);
            Swal.fire({
                title: "Error",
                text: `Error inesperado: ${error.message}`,
                icon: "error",
                confirmButtonText: "OK"
            });
        }

        console.log("=== FIN guardarCambiosEvento ===");
    }

    function eliminarEvento(id) {
        Swal.fire({
            title: "¿Estás seguro?",
            text: "Esta acción eliminará el evento.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Sí, eliminar",
            cancelButtonText: "Cancelar"
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('/ServiciosCalendario.asmx/EliminarEvento', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ id: id })
                })
                    .then(r => r.json())
                    .then(data => {
                        if (data.d === true) {
                            Swal.fire("Eliminado", "El evento fue eliminado.", "success")
                                .then(() => {
                                    // Mantener el mes actual al recargar
                                    window.location.href = `NuevoEvento.aspx?mes=${mesActual}&año=${añoActual}`;
                                });
                        } else {
                            Swal.fire("Error", "No se pudo eliminar el evento.", "error");
                        }
                    })
                    .catch(error => {
                        console.error("Error al eliminar evento:", error);
                        Swal.fire("Error", "Fallo en la eliminación.", "error");
                    });
            }
        });
    }
</script>

</asp:Content>

