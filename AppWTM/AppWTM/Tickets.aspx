<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="AppWTM.Tickets" %>
<asp:Content ID="Tickets" ContentPlaceHolderID="MainContent" runat="server">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark/dark.css">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
<link href="Styles/crearticket.css" rel="stylesheet" type="text/css" />
    <style>
        /* SOLUCIÓN: Indicadores de estado circulares */
.status-indicator {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    display: inline-block;
    margin-right: 8px;
    border: 2px solid transparent;
    transition: var(--transition);
}

/* Colores específicos para cada estado */
.status-activo {
    background-color: #28a745;
    border-color: #1e7e34;
}

.status-pendiente {
    background-color: var(--accent-yellow);
    border-color: #e0a800;
}

.status-resuelto {
    background-color: #17a2b8;
    border-color: #138496;
}
   
    .star {
        font-size: 2rem;
        color: #ccc;
        cursor: pointer;
    }
    .star.selected{
        color: gold;
    }



.status-cancelado {
    background-color: #dc3545;
    border-color: #c82333;
}

.status-en-proceso {
    background-color: var(--primary-purple);
    border-color: #6a0e42;
}
    </style>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8">

            <asp:Repeater ID="rptTickets" runat="server" OnItemDataBound="rptTickets_ItemDataBound">
    <ItemTemplate>
        <div class="ticket-card d-flex mb-3 border rounded" data-bs-toggle="modal" data-bs-target="#ticketModal_<%# Eval("Id_Ticket") %>">
            <!-- Encabezado con ID del ticket -->
            <header class="card-header d-flex flex-column align-items-center" style="width: 80px;">
                <div class="rounded-circle d-flex align-items-center justify-content-center mb-1 <%# GetCircleClass(Eval("Estado").ToString()) %>" style="width: 60px; height: 60px;">
                    <span class="fw-bold"><%# Eval("Id_Ticket") %></span>
                </div>
            </header>

            <!-- Cuerpo de la tarjeta -->
            <div class="card-body">
                <h5 class="card-text"><%# Eval("Título") %></h5>
                <p class="card-text">Área: <%# Eval("Departamento") %></p>
                <div class="d-flex justify-content-start">
                    <!-- Badge de Prioridad -->
                    <span class='badge <%# GetBadgeClass(Eval("Prioridad").ToString(), "prioridad") %> me-2'>
                        <%# Eval("Prioridad") %>
                    </span>
                    <!-- Badge de Estado -->
                   <span class='badge <%# GetBadgeClass(Eval("Estado").ToString(), "estado") %>'>
                        <%# Eval("Estado") %>
                    </span>
                        
                </div>
                <div class="mt-2">
                  <small class="text-muted">
                    Responsable: <%# Eval("Agente") %>
                  </small>
                </div>
            </div>
        </div>

                    <!-- Modal -->
                    <div class="modal fade" id="ticketModal_<%# Eval("Id_Ticket") %>" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
                        <asp:HiddenField ID="hfTicketID" runat="server" />
                        <div class="modal-dialog" style="max-width: 50%;">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title" id="ticketModalLabel">Detalles del Ticket: <%# Eval("Id_Ticket") %></h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="container-fluid">
                                        <!-- Card con los detalles del ticket -->
                                        <div class="card shadow-sm">
                                            <div class="card-body">
                                                <h6 class="card-title"><b>Título:</b> <%# Eval("Título") %></h6>
                                                
                                                <p><b>Área:</b> <%# Eval("Departamento") %></p>
                                                <p><b>Descripción:</b> <%# Eval("Descripción") %></p>
                                                <p><b>Responsable:</b> <%# Eval("Agente") %></p>
                                                <asp:Panel ID="pnlEvidencia" runat="server"
                                                    Visible='<%# !string.IsNullOrEmpty(Eval("Tick_EvidenciaRuta").ToString()) %>'
                                                    CssClass="mt-3 text-center">
                                                    
                                                <p><b>Evidencia de resolución:</b></p>
                                                    <asp:HyperLink 
                                                        ID="hlEvidencia" 
                                                        runat="server" 
                                                        NavigateUrl='<%# Eval("Tick_EvidenciaRuta") %>' 
                                                        Target="_blank"
                                                        CssClass="btn btn-outline-primary btn-sm">
                                                        <i class="bi bi-file-earmark-pdf"></i> Ver Evidencia
                                                    </asp:HyperLink>

                                                </asp:Panel>


                                                    <asp:Panel ID="calificacionEstrellas" runat="server" CssClass="mt-3">
                                                         <label class="form-label">Califica el servicio del agente:</label>
                                                                <div id="starsContainer" class="stars text-center mb-3">
                                                                    <span class='<%# GetStarClass(Eval("Tick_Calificacion"), 1) %>' data-value="1">&#9733;</span>
                                                                    <span class='<%# GetStarClass(Eval("Tick_Calificacion"), 2) %>' data-value="2">&#9733;</span>
                                                                    <span class='<%# GetStarClass(Eval("Tick_Calificacion"), 3) %>' data-value="3">&#9733;</span>
                                                                    <span class='<%# GetStarClass(Eval("Tick_Calificacion"), 4) %>' data-value="4">&#9733;</span>
                                                                    <span class='<%# GetStarClass(Eval("Tick_Calificacion"), 5) %>' data-value="5">&#9733;</span>
                                                                </div>

                                                                  <!-- HiddenFields para ID y calificación -->
                                                            <asp:HiddenField 
                                                                ID="HiddenField1" 
                                                                runat="server"
                                                                Value='<%# Eval("Id_Ticket") %>' />
                                                            <asp:HiddenField 
                                                                ID="hfCalificacion" 
                                                                runat="server" />


                                                            <!-- Botón que dispara el postback y llamará a btnGuardarCalificacion_Click -->
                                                            <asp:Button
                                                                ID="btnGuardarCalificacion"
                                                                runat="server"
                                                                Text="Guardar Calificación"
                                                                CssClass="btn btn-success"
                                                                OnClick="btnGuardarCalificacion_Click" />
                                                        </asp:Panel>

                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer d-flex justify-content-center">
                                    <div id="botonCancelacion" class="mt-3 <%# Eval("Estado").ToString() != "Resuelto" ? "" : "d-none" %>">
                                        <asp:Button 
                                            ID="btnCancelarTicket" 
                                            runat="server" 
                                            Text="Cancelar Ticket" 
                                            CssClass="btn btn-danger btn-sm"
                                            OnClick="btnCancelarTicket_Click" 
                                            CommandArgument='<%# Eval("Id_Ticket") %>' />
                                    </div>
                                 <div class="form-check form-switch" >
                                        <asp:CheckBox ID="SwitchSeleccionarTicket" runat="server" CssClass="form-check-input" Visible ="false" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                </ItemTemplate>
            </asp:Repeater>

            <!-- Contenedor para las estadísticas del Administrador -->
            <div id="divEstadisticas" runat="server" visible="false">
                <h2 class="mb-4">Estadísticas de Tickets</h2>
                <div class="d-flex flex-wrap gap-3">
                    <asp:Repeater ID="rptEstadisticas" runat="server">
                        <ItemTemplate>
                            <div class="stats-card <%# GetCardClass(Eval("Estado").ToString()) %>">
                                <div class="count"><%# Eval("Cantidad") %></div>
                                <div class="state"><%# Eval("Estado") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

        </div>
        <!-- Columna del Botón -->
        <div class="col-md-4 d-flex align-items-start justify-content-center">
            <button type="button" class="btn btn-primary mt-2 w-75" data-bs-toggle="modal" data-bs-target="#crearTicketModal">Crear Ticket</button>
        </div>

    </div>
</div>

    <div class="modal fade" id="crearTicketModal" tabindex="-1" aria-labelledby="crearTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog <%--modal-lg--%>" style="max-width: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="crearTicketModalLabel">Crear Nuevo Ticket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Contenido del formulario dentro del modal -->
                    <main aria-labelledby="title">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-lg-12 mx-auto">
                                    <div>
                                        <div class="card-header text-black text-center">
                                            <h4>Envíe una nueva solicitud</h4>
                                        </div>
                                        <div class="card-body row mt-1">
                                            <div class="col-12 mb-2">
                                                <label for="txtTitulo" class="form-label">Título de la Solicitud</label>
                                                <div class="row">
                                                    <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control mx-auto" placeholder="Título de la solicitud" style="width: 90%;"></asp:TextBox>
                                                    <small class="form-text text-muted" style="text-align: left; margin-left: 3rem;">Máx. 50 caracteres</small>
                                                </div>
                                            </div>
                                            <div class="mt-1">
                                                <label for="ddlArea" class="form-label">Área o Departamento</label>
                                                <div class="row">
                                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select mx-auto" style="width: 90%;"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="mt-1">
                                                <label for="txtDescripcion" class="form-label mt-1">Descripción</label>
                                                <div class="row">
                                                    <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" CssClass="form-control mx-auto" placeholder="Describa los detalles de su solicitud" style="width: 90%; text-align: left;" rows="4"></asp:TextBox>
                                                    <small class="form-text text-muted" style="text-align: left; margin-left: 3rem;">Sea específico</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer">
                                            <div style="display: flex; justify-content: center; gap: 15px;">
                                                <asp:Button ID="btnCancelar" runat="server" CssClass="btn btn-secondary" Text="Cancelar"  style="width: 120px;" OnClick="btnCancelar_Click"/>
                                                <asp:Button ID="btnEnviar" runat="server" CssClass="btn btn-primary" Text="Enviar"  style="width: 120px;" OnClick="btnEnviar_Click"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </div>
    </div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
        function abrirModalDetalles(ticket) {
            document.getElementById("detalleId").textContent = ticket.id;
            document.getElementById("detalleEstado").textContent = ticket.estado;
            document.getElementById("detalleDescripcion").textContent = ticket.descripcion;

            // Mostrar calificación solo si el ticket está resuelto
            if (ticket.estado === "Resuelto") {
                document.getElementById("calificacionEstrellas").style.display = "block";
            } else {
                document.getElementById("calificacionEstrellas").style.display = "none";
            }

            let modal = new bootstrap.Modal(document.getElementById("modalDetalles"));
            modal.show();

            document.querySelectorAll('[id^="ticketModal_"]').forEach(modalEl => {
                modalEl.addEventListener('shown.bs.modal', function () {
                    const $modal = this;
                    // 1) lee la calificación del atributo data-rating (inyectado en server-side)
                    const rating = parseInt($modal.querySelector('[id*="starsContainer"]').getAttribute('data-rating') || "0");
                    if (rating > 0) {
                        // 2) pinta esas estrellas
                        const stars = $modal.querySelectorAll('.star');
                        stars.forEach(s => {
                            if (parseInt(s.dataset.value) <= rating) s.classList.add('selected');
                        });
                    }
                });
            });
        }
</script>
<script>
    // Cada vez que el usuario hace click en una estrella...
    $(document).on('click', '.star', function () {
        var val = $(this).data('value'),
            $modal = $(this).closest('.modal-content');

        // 1) Pinto las estrellas
        $modal.find('.star').each(function () {
            $(this).toggleClass('selected', $(this).data('value') <= val);
        });

        // 2) Guardo la calificación en el HiddenField de ESTA fila
        $modal.find('input[id$="hfCalificacion"]').val(val);
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const stars = document.querySelectorAll("#rating-stars .star");
        const selectedRatingInput = document.getElementById("selectedRating");

        stars.forEach(star => {
            star.addEventListener("click", () => {
                const value = star.getAttribute("data-value");

                // Guardar el valor seleccionado
                selectedRatingInput.value = value;

                // Quitar selección previa
                stars.forEach(s => s.classList.remove("selected"));

                // Agregar selección actual
                for (let i = 0; i < value; i++) {
                    stars[i].classList.add("selected");
                }
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".stars").forEach(function (starGroup) {
                const stars = starGroup.querySelectorAll(".star");

                stars.forEach(function (star) {
                    star.addEventListener("click", function () {
                        const value = this.getAttribute("data-value");
                        const parent = this.closest(".stars");

                        // Limpiar selección previa
                        parent.querySelectorAll(".star").forEach(s => s.classList.remove("selected"));

                        // Marcar estrellas hasta la seleccionada
                        for (let i = 0; i < value; i++) {
                            parent.querySelectorAll(".star")[i].classList.add("selected");
                        }

                        // Buscar el hiddenField que está justo después del grupo de estrellas
                        const hf = parent.parentElement.querySelector("input[id*='hfCalificacion']");
                        if (hf) {
                            hf.value = value;
                        }
                    });
                });
            });
        });
    </script>
</asp:Content>
