<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="AppWTM.Tickets" %>
<asp:Content ID="Tickets" ContentPlaceHolderID="MainContent" runat="server">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark/dark.css">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
    .form-switch .form-check-input {
    width: 40px;
    height: 20px;
    background-color: #ccc;
    border-radius: 20px;
    position: relative;
    transition: background-color 0.3s;
    cursor: pointer;
    }

    .form-switch .form-check-input:checked {
        background-color: #28a745;
    }

    .form-switch .form-check-input:before {
        content: '';
        position: absolute;
        width: 16px;
        height: 16px;
        top: 2px;
        left: 2px;
        background-color: white;
        border-radius: 50%;
        transition: transform 0.3s;
    }

    .form-switch .form-check-input:checked:before {
        transform: translateX(20px);
    }

    #divEstadisticas {
        margin-top: 20px;
    }

    .stats-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        text-align: center;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .stats-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
    }

    .stats-card .state {
        font-size: 1.2rem;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .stats-card .count {
        font-size: 2rem;
        font-weight: bold;
        margin-bottom: 5px;
    }

    /* Colores personalizados para diferentes estados */
    .stats-card.pendiente {
        background-color: #f9c74f;
    }

    .stats-card.en-progreso {
        background-color: #43aa8b;
        color: #fff;
    }

    .stats-card.resuelto {
        background-color: #577590;
        color: #fff;
    }

    .stats-card.cancelado {
        background-color: #f94144;
        color: #fff;
    }
    .stats-card.activo {
        background-color: #90be6d;
        color: #fff;
    }
    .card-header div {
        font-size: 1.2rem;
        font-weight: bold;
    }

    .card-body h3 {
        color: #333;
        margin-bottom: 10px;
    }

    .card-body h5 {
        color: #555;
        font-weight: bold;
    }

    .card-body .badge {
        font-size: 0.9rem;
        padding: 0.5em 0.8em;
        margin-bottom: 5px; /* Separación del borde inferior */
    }

    /* Ajustar ancho de las tarjetas */
    .ticket-card {
        max-width: 600px; /* Hacerlas más compactas */
    }

    /* Efecto hover */
        .ticket-card:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra */
            transform: translateY(-5px); /* Elevación */
            transition: all 0.3s ease; /* Suavidad del efecto */
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
                            <div class="rounded-circle bg-light d-flex align-items-center justify-content-center mb-1" style="width: 60px; height: 60px;">
                                <span class="fw-bold text-dark"><%# Eval("Id_Ticket") %></span>
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

<%--                                                <!-- Estado Dropdown -->
                                                <div class="mt-3" ID="SelectEstado" Visible="false">
                                                    <label for="ddlEstado_<%# Eval("Id_Ticket") %>" class="form-label">Estado</label>
                                                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select" style="width: 100%;">
                                                        <asp:ListItem Text="Selecciona un Estado" Value="0" />
                                                        <asp:ListItem Text="Activo" Value="1" />
                                                        <asp:ListItem Text="Pendiente" Value="2" />
                                                        <asp:ListItem Text="Resuelto" Value="3" />
                                                        <asp:ListItem Text="Cancelado" Value="4" />
                                                        <asp:ListItem Text="En Proceso" Value="5" />
                                                    </asp:DropDownList>
                                                </div>

                                                <!-- Agente Dropdown -->
                                                <div class="mt-3" ID="SelectDepartamento" Visible="false">
                                                    <label for="ddlDepartTicket_<%# Eval("Id_Ticket") %>" class="form-label">Departamento</label>
                                                    <asp:DropDownList ID="ddlDepartTicket" runat="server" CssClass="form-select" style="width: 100%;"></asp:DropDownList>
                                                    
                                                </div>--%>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer d-flex justify-content-center">
                                <asp:Button 
                                    ID="btnCancelarTicket" 
                                    runat="server" 
                                    Text="Cancelar Ticket" 
                                    CssClass="btn btn-danger btn-sm"
                                    OnClick="btnCancelarTicket_Click" 
                                    CommandArgument='<%# Eval("Id_Ticket") %>' />
                                <%--<asp:Button ID="BtnActualizar" runat="server" Text="Actualizar" CssClass="btn btn-warning mx-2" Visible="false" OnClick="BtnActualizar_Click"/>
                                --%>    <div class="form-check form-switch" >
                                        <asp:CheckBox ID="SwitchSeleccionarTicket" runat="server" CssClass="form-check-input" Visible ="false" />
                                        <label class="form-check-label" for="SwitchSeleccionarTicket">Seleccionar Ticket</label>
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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
