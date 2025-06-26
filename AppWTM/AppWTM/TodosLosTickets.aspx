<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.Master"
    CodeBehind="TodosLosTickets.aspx.cs"
    Inherits="AppWTM.TodosLosTickets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="Styles/crearticket.css" rel="stylesheet" type="text/css" />
    <style>
               /* Variables de colores */
:root {
  --primary-yellow: #fec526;
  --primary-blue: #0f1d60;
  --primary-purple: #801250;
  --primary-white: #ffffff;
  --success-green: #28a745;
  --warning-orange: #fd7e14;
  --danger-red: #dc3545;
  --info-cyan: #17a2b8;
  --secondary-gray: #6c757d;
  --light-gray: #f8f9fa;
  --border-color: #dee2e6;
}

/* Título principal */
.h2 {
    font-size: 2rem;
    font-weight: 600;
    color: #000000;
    margin: 0;
    padding-left: 1rem;
    border-left: 4px solid #fec526;
    flex-shrink: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Contenedor del perfil */
.h2::after {
    max-width: 900px;
    margin: 2rem auto;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(15, 29, 96, 0.1);
    padding: 2rem;
    border: 1px solid #e8e9ea;
}


/* Pestañas de navegación */
.nav-tabs {
  border: none;
  justify-content: center;
  margin-bottom: 2rem;
  background: var(--primary-white);
  border-radius: 15px;
  padding: 0.5rem;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.nav-tabs .nav-item {
  margin: 0 0.25rem;
}

.nav-tabs .nav-link {
  border: none;
  border-radius: 12px;
  padding: 12px 20px;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.85rem;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.nav-tabs .nav-link::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transition: left 0.5s ease;
}

.nav-tabs .nav-link:hover::before {
  left: 100%;
}



/*diseño de los botones*/
#todos-tab {
  background: linear-gradient(135deg, var(--primary-blue), #1a2a7a);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(15, 29, 96, 0.3);
}

#todos-tab:hover, #todos-tab.active {
  background: linear-gradient(135deg, #1a2a7a, var(--primary-blue));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(15, 29, 96, 0.4);
}

/* Sin asignar */
#sinAsignar-tab {
  background: linear-gradient(135deg, var(--secondary-gray), #5a6268);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
}

#sinAsignar-tab:hover, #sinAsignar-tab.active {
  background: linear-gradient(135deg, #5a6268, var(--secondary-gray));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
}

/* Asignados a mí */
#asignadosMi-tab {
  background: linear-gradient(135deg, var(--primary-yellow), #e6b121);
  color: var(--primary-blue);
  box-shadow: 0 4px 15px rgba(254, 197, 38, 0.3);
}

#asignadosMi-tab:hover, #asignadosMi-tab.active {
  background: linear-gradient(135deg, #e6b121, var(--primary-yellow));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(254, 197, 38, 0.4);
}

/* Activos */
#activos-tab {
  background: linear-gradient(135deg, var(--success-green), #34ce57);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
}

#activos-tab:hover, #activos-tab.active {
  background: linear-gradient(135deg, #34ce57, var(--success-green));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
}

/* Pendientes */
#pendientes-tab {
  background: linear-gradient(135deg, var(--warning-orange), #e8681b);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(253, 126, 20, 0.3);
}

#pendientes-tab:hover, #pendientes-tab.active {
  background: linear-gradient(135deg, #e8681b, var(--warning-orange));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(253, 126, 20, 0.4);
}

/* Resueltos */
#resueltos-tab {
  background: linear-gradient(135deg, var(--info-cyan), #138496);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
}

#resueltos-tab:hover, #resueltos-tab.active {
  background: linear-gradient(135deg, #138496, var(--info-cyan));
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(23, 162, 184, 0.4);
}

/* Cancelados */
#cancelados-tab {
  background: linear-gradient(135deg, var(--danger-red), #c82333);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
}

#cancelados-tab:hover, #cancelados-tab.active {
  background: linear-gradient(135deg, #c82333, var(--danger-red));
 /* transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);*/
}
/* Prioridad */
#prioridad-tab {
  background: linear-gradient(135deg, #a255c6, #8e3bb2);
  color: var(--primary-white);
  box-shadow: 0 4px 15px rgba(162, 85, 198, 0.3);
}

#prioridad-tab:hover, #prioridad-tab.active {
  background: linear-gradient(135deg, #8e3bb2, #a255c6);
 /* transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(162, 85, 198, 0.4);*/
}


/* Cards de tickets */
.card {
  border: none;
  border-radius: 15px;
  transition: all 0.3s ease;
  background: var(--primary-white);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
}

.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-yellow), var(--primary-purple));
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 35px rgba(15, 29, 96, 0.15);
}

.card-body {
  padding: 1.5rem;
  position: relative;
}

.card-title {
  color: var(--primary-blue);
  font-weight: 700;
  font-size: 1.1rem;
  margin-bottom: 1rem;
  line-height: 1.3;
}

.card-text {
  color: #666;
  font-size: 0.9rem;
  line-height: 1.5;
}

/* Badges */
.badge {
  font-size: 0.75rem;
  padding: 0.5em 0.8em;
  border-radius: 8px;
  font-weight: 600;
  margin-right: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.badge.bg-primary {
  background: linear-gradient(135deg, var(--primary-blue), #1a2a7a) !important;
}

.badge.bg-secondary {
  background: linear-gradient(135deg, var(--primary-purple), #a01560) !important;
}

/* Botones */
.btn {
  border-radius: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  border: none;
  position: relative;
  overflow: hidden;
}

.btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.3s ease, height 0.3s ease;
}

.btn:hover::before {
  width: 300px;
  height: 300px;
}

.btn-outline-primary {
  color: var(--primary-blue);
  border: 2px solid var(--primary-blue);
  background: transparent;
}

.btn-outline-primary:hover {
  background: var(--primary-blue);
  color: var(--primary-white);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(15, 29, 96, 0.3);
}

.btn-primary {
  background: linear-gradient(135deg, var(--primary-yellow), #e6b121);
  color: var(--primary-blue);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #e6b121, var(--primary-yellow));
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(254, 197, 38, 0.4);
}

.btn-secondary {
  background: linear-gradient(135deg, var(--secondary-gray), #5a6268);
  color: var(--primary-white);
}

.btn-secondary:hover {
  background: linear-gradient(135deg, #5a6268, var(--secondary-gray));
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
}

/* Modal */
.modal-content {
  border: none;
  border-radius: 20px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
  overflow: hidden;
}

.modal-header {
   background: linear-gradient(135deg, #801250 0%, #b03060 100%);
  color: var(--primary-white);
  border: none;
  padding: 1.5rem 2rem;
}

.modal-title {
  font-weight: 700;
  font-size: 1.3rem;
}

.btn-close {
  filter: invert(1);
  opacity: 0.8;
}

.btn-close:hover {
  opacity: 1;
}

.modal-body {
  padding: 2rem;
  background: var(--light-gray);
}

.modal-footer {
  background: var(--primary-white);
  border: none;
  padding: 1.5rem 2rem;
}

/* Formularios */
.form-select, .form-control {
  border-radius: 10px;
  border: 2px solid var(--border-color);
  padding: 0.75rem 1rem;
  transition: all 0.3s ease;
}

.form-select:focus, .form-control:focus {
  border-color: var(--primary-yellow);
  box-shadow: 0 0 0 0.2rem rgba(254, 197, 38, 0.25);
}

/* Estrellas de calificación */
.star {
  font-size: 2rem;
  color: #ddd;
  cursor: pointer;
  transition: all 0.2s ease;
  margin: 0 0.2rem;
}

.star:hover {
  color: var(--primary-yellow);
  transform: scale(1.1);
}

.star.selected {
  color: var(--primary-yellow);
  text-shadow: 0 0 10px rgba(254, 197, 38, 0.5);
}

/* Efectos de texto */
.text-muted {
  color: #888 !important;
  font-size: 0.85rem;
}

/* Animaciones */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card {
  animation: fadeInUp 0.6s ease;
}

/* Responsive */
@media (max-width: 768px) {
  .nav-tabs {
    flex-direction: column;
    align-items: stretch;
  }
  
  .nav-tabs .nav-item {
    margin: 0.25rem 0;
  }
  
  .nav-tabs .nav-link {
    text-align: center;
  }
  
  .container {
    padding: 1rem;
    margin-top: 1rem;
  }
  
  .card-body {
    padding: 1rem;
  }
}

/* Estados especiales para cards según el estado del ticket */
.card[data-estado="Resuelto"]::before {
  background: linear-gradient(90deg, var(--success-green), #34ce57);
}

.card[data-estado="Cancelado"]::before {
  background: linear-gradient(90deg, var(--danger-red), #c82333);
}

.card[data-estado="Pendiente"]::before {
  background: linear-gradient(90deg, var(--warning-orange), #e8681b);
}

.card[data-estado="Activo"]::before {
  background: linear-gradient(90deg, var(--success-green), #34ce57);
}

/* Hover effects mejorados */
.nav-tabs .nav-link:not(.active):hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}
.nav-tabs .nav-link:hover,
.nav-tabs .nav-link.active {
  transform: translateY(-15px) !important;
  box-shadow: 0 16px 50px rgba(0, 0, 0, 0.35) !important;
}



/* Indicadores de estado visual */
.badge-status-indicator {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.badge-status-indicator.active {
  background-color: var(--success-green);
}

.badge-status-indicator.pending {
  background-color: var(--warning-orange);
}

.badge-status-indicator.resolved {
  background-color: var(--info-cyan);
}

.badge-status-indicator.cancelled {
  background-color: var(--danger-red);
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 currentColor;
    opacity: 1;
  }
  70% {
    box-shadow: 0 0 0 10px transparent;
    opacity: 0;
  }
  100% {
    box-shadow: 0 0 0 0 transparent;
    opacity: 0;
  }
}

    </style>
  <div class="container mt-4">
    <h2>
      <asp:Label ID="lblTitulo" runat="server" Text="Tickets de Mi Área"></asp:Label>
    </h2>

    <!-- NAV TABS -->
    <ul class="nav nav-tabs mb-3" id="ticketTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active"
                id="todos-tab"
                data-bs-toggle="tab"
                data-bs-target="#todos"
                type="button"
                role="tab"
                aria-controls="todos"
                aria-selected="true">
          Todos
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link"
                id="sinAsignar-tab"
                data-bs-toggle="tab"
                data-bs-target="#sinAsignar"
                type="button"
                role="tab"
                aria-controls="sinAsignar"
                aria-selected="false">
          Sin asignar
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link"
                id="asignadosMi-tab"
                data-bs-toggle="tab"
                data-bs-target="#asignadosMi"
                type="button"
                role="tab"
                aria-controls="asignadosMi"
                aria-selected="false">
          Asignados a mí
        </button>
      </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link"
                  id="activos-tab"
                  data-bs-toggle="tab"
                  data-bs-target="#tab-activos"
                  type="button"
                  role="tab"
                  aria-controls="activos"
                  aria-selected="false">
            Activos
          </button>
        </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link"
                id="pendientes-tab"
                data-bs-toggle="tab"
                data-bs-target="#pendientes"
                type="button"
                role="tab"
                aria-controls="pendientes"
                aria-selected="false">
          Pendientes
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link"
                id="resueltos-tab"
                data-bs-toggle="tab"
                data-bs-target="#resueltos"
                type="button"
                role="tab"
                aria-controls="resueltos"
                aria-selected="false">
          Resueltos
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link"
                id="cancelados-tab"
                data-bs-toggle="tab"
                data-bs-target="#cancelados"
                type="button"
                role="tab"
                aria-controls="cancelados"
                aria-selected="false">
          Cancelados
        </button>
      </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link"
                  id="prioridad-tab"
                  data-bs-toggle="tab"
                  data-bs-target="#prioridad"
                  type="button"
                  role="tab"
                  aria-controls="prioridad"
                  aria-selected="false">
            Prioridad
          </button>
        </li>
    </ul>

    <!-- TAB CONTENT -->
    <div class="tab-content" id="ticketTabsContent">

      <!-- ========== 1) TODOS ========== -->
      <div class="tab-pane fade show active" id="todos" role="tabpanel" aria-labelledby="todos-tab">
        <div class="row">
          <asp:Repeater ID="rptTodos"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalleTodos"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>
                      <br /><br />
                                      <!-- Asignarme -->
                <asp:Button ID="btnAsignarTodos"
                            runat="server"
                            CssClass="btn btn-sm btn-outline-primary"
                            Text="Asignarme"
                            CommandName="Asignar"
                            CommandArgument='<%# Eval("Id_Ticket") %>'
                            Visible='<%# Eval("Agente").ToString() == "Sin asignar" %>'
                            OnClientClick="return confirmAssign(this);" />
                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

      <!-- ========== 2) SIN ASIGNAR ========== -->
      <div class="tab-pane fade" id="sinAsignar" role="tabpanel" aria-labelledby="sinAsignar-tab">
        <div class="row">
          <asp:Repeater ID="rptSinAsignar"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalle2"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>
                                            <br /><br />
                                      <!-- Asignarme -->
                <asp:Button ID="btnAsignarTodos"
                            runat="server"
                            CssClass="btn btn-sm btn-outline-primary"
                            Text="Asignarme"
                            CommandName="Asignar"
                            CommandArgument='<%# Eval("Id_Ticket") %>'
                            Visible='<%# Eval("Agente").ToString() == "Sin asignar" %>'
                            OnClientClick="return confirmAssign(this);" />
                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

      <!-- ========== 3) ASIGNADOS A MÍ ========== -->
      <div class="tab-pane fade" id="asignadosMi" role="tabpanel" aria-labelledby="asignadosMi-tab">
        <div class="row">
          <asp:Repeater ID="rptAsignadosMi"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalle3"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>

                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

     <!-- Activos -->

        <div class="tab-pane fade" id="tab-activos">
            <asp:Repeater ID="rptActivos" runat="server" OnItemDataBound="rptTicketsArea_ItemDataBound" OnItemCommand="rptTicketsArea_ItemCommand">
                <ItemTemplate>
                  <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                    <asp:LinkButton ID="lnkVerDetalle4"
                                    runat="server"
                                    CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("Id_Ticket") %>'>
                      <div class="card-body">
                        <h5 class="card-title"><%# Eval("Título") %></h5>
                        <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                        <div class="mb-2">
                          <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                            <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                        </div>
                        <small class="text-muted">
                          #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                        </small><br/>
                        <small class="text-muted">
                          Solicitante: <%# Eval("Usuario") %>
                        </small><br/>
                        <small class="text-muted">
                          Agente: <%# Eval("Agente") %>
                        </small>
                      </div>
                    </asp:LinkButton>
                  </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>


      <!-- ========== 4) PENDIENTES ========== -->
      <div class="tab-pane fade" id="pendientes" role="tabpanel" aria-labelledby="pendientes-tab">
        <div class="row">
          <asp:Repeater ID="rptPendientes"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalle4"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>
                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

      <!-- ========== 5) RESUELTOS ========== -->
      <div class="tab-pane fade" id="resueltos" role="tabpanel" aria-labelledby="resueltos-tab">
        <div class="row">
          <asp:Repeater ID="rptResueltos"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalle5"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>
                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

      <!-- ========== 6) CANCELADOS ========== -->
      <div class="tab-pane fade" id="cancelados" role="tabpanel" aria-labelledby="cancelados-tab">
        <div class="row">
          <asp:Repeater ID="rptCancelados"
                        runat="server"
                        OnItemCommand="rptTicketsArea_ItemCommand"
                        OnItemDataBound="rptTicketsArea_ItemDataBound">
            <ItemTemplate>
              <div id="ticketContainer" runat="server"  class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <asp:LinkButton ID="lnkVerDetalle6"
                                runat="server"
                                CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id_Ticket") %>'>
                  <div class="card-body">
                    <h5 class="card-title"><%# Eval("Título") %></h5>
                    <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                    <div class="mb-2">
                      <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
                    </div>
                    <small class="text-muted">
                      #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
                    </small><br/>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Agente: <%# Eval("Agente") %>
                    </small>
                  </div>
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>
    </div>
  </div>


    <div class="tab-pane fade" id="prioridad" role="tabpanel" aria-labelledby="prioridad-tab">
  <div class="row">
    <asp:Repeater ID="rptPrioridad"
                  runat="server"
                  OnItemCommand="rptTicketsArea_ItemCommand"
                  OnItemDataBound="rptTicketsArea_ItemDataBound">
      <ItemTemplate>
        <div id="ticketContainer" runat="server" class="col-sm-6 col-md-4 col-lg-3 mb-4">
          <asp:LinkButton ID="lnkVerDetallePrioridad"
                          runat="server"
                          CssClass="card h-100 text-start text-decoration-none text-dark mb-2"
                          CommandName="VerDetalle"
                          CommandArgument='<%# Eval("Id_Ticket") %>'>
            <div class="card-body">
              <h5 class="card-title"><%# Eval("Título") %></h5>
              <p class="card-text mb-1"><%# Eval("Descripción") %></p>
              <div class="mb-2">
                <span class="badge bg-primary" data-prioridad='<%# Eval("PrioridadAreaTexto") %>'><%# Eval("PrioridadAreaTexto") %></span>
                <span class="badge bg-secondary" data-estado='<%# Eval("Estado") %>'><%# Eval("Estado") %></span>
              </div>
              <small class="text-muted">
                #<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %>
              </small><br/>
              <small class="text-muted">
                Solicitante: <%# Eval("Usuario") %>
              </small><br/>
              <small class="text-muted">
                Agente: <%# Eval("Agente") %>
              </small>
            </div>
          </asp:LinkButton>
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </div>
</div>

  <!-- Modal de detalle-->
  <div class="modal fade" runat="server" id="ticketDetalleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Detalle del Ticket</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <dl class="row">
            <dt class="col-sm-3">Título</dt>
            <dd class="col-sm-9"><asp:Label ID="lblDetTitulo" runat="server" /></dd>

            <dt class="col-sm-3">Descripción</dt>
            <dd class="col-sm-9"><asp:Label ID="lblDetDescripcion" runat="server" /></dd>

            <dt class="col-sm-3">Solicitante</dt>
            <dd class="col-sm-9"><asp:Label ID="lblDetSolicitante" runat="server" /></dd>

            <dt class="col-sm-3" id="lblEstado" runat="server">Estado</dt>
            <dd class="col-sm-9">
              <asp:DropDownList ID="ddlDetEstado" runat="server" CssClass="form-select" />
            </dd>
          </dl>
            <asp:HiddenField ID="hfAgenteId" runat="server" />
        </div>
        <asp:Panel ID="calificacionEstrellas" runat="server" CssClass="mt-4 border-top pt-3">
          <h5 class="mb-3" runat="server" id="lblCalif">
            Calificación del servicio:
          </h5>

          <div class="stars text-center mb-3">
            <asp:Literal ID="litStars" runat="server" />
          </div>

          <h5 class="mt-4">
            <i class="bi bi-file-earmark-arrow-up"></i> Evidencia del servicio (PDF)
          </h5>

          <asp:Label ID="lblFileMessage"
                     runat="server"
                     CssClass="alert alert-warning mt-2 p-2"
                     Visible="false" />

          <div class="input-group mt-2">
            <span class="input-group-text"><i class="bi bi-upload"></i></span>
            <asp:FileUpload ID="fuEvidencia" runat="server" CssClass="form-control" Accept=".pdf" />
          </div>

          <asp:HyperLink 
              ID="lnkVerPDF" 
              runat="server" 
              Text="📎 Ver evidencia actual"
              Target="_blank" 
              CssClass="btn btn-outline-primary mt-3 d-block w-100"
              Visible="false" />
        </asp:Panel>


          
        <asp:HiddenField ID="hfCalificacion" runat="server" />
        <div class="modal-footer">
        <asp:Button ID="btnGuardarEvidencia" runat="server"
            CssClass="btn btn-success me-2 d-none"
            Text="Subir Evidencia"
            OnClick="btnGuardarEvidencia_Click"
            ClientIDMode="Static" />

          <asp:Button ID="btnCambiarEstado"
                      runat="server"
                      CssClass="btn btn-primary"
                      Text="Guardar cambios"
                      OnClick="btnCambiarEstado_Click" />
          <button type="button" class="btn btn-secondary"
                  data-bs-dismiss="modal">
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </div>
    <asp:ScriptManagerProxy runat="server" ID="ScriptManagerProxy1" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const fileInput = document.getElementById('<%= fuEvidencia.ClientID %>');
    const uploadButton = document.getElementById('<%= btnGuardarEvidencia.ClientID %>');

      if (fileInput && uploadButton) {
          fileInput.addEventListener("change", function () {
              if (fileInput.files.length > 0) {
                  uploadButton.classList.remove("d-none");
              } else {
                  uploadButton.classList.add("d-none");
              }
          });
      }
  });
</script>
</asp:Content>
