<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.Master"
    CodeBehind="TodosLosTickets.aspx.cs"
    Inherits="AppWTM.TodosLosTickets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <link href="Styles/todoslostickets.css" rel="stylesheet" />
    <style>
        .star {
          font-size: 2rem;        /* tamaño grande */
          color: #ccc;            /* gris por defecto */
          cursor: pointer;
          transition: color .2s;
        }

        .star.selected {
          color: gold;            /* o el color que quieras para “relleno” */
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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

                <asp:Button ID="btnAsignar2"
                            runat="server"
                            CssClass="btn btn-sm btn-outline-primary"
                            Text="Asignarme"
                            CommandName="Asignar"
                            CommandArgument='<%# Eval("Id_Ticket") %>'
                            Visible='<%# Eval("Agente").ToString() == "Sin asignar" %>'
                            OnClientClick="return confirmAssign(this);" />
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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
                    <!-- Asegúrate de copiar aquí la misma tarjeta de ticket que usas en otros Repeaters -->
                    <div id="ticketContainer" runat="server" class="card my-2">
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Ticket_Titulo") %></h5>
                            <p class="card-text"><%# Eval("Tick_Descripcion") %></p>

                            <!-- Botón para ver detalles -->
                            <asp:LinkButton ID="lnkVerDetalle7" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("Id_Ticket") %>' CssClass="btn btn-primary">
                                Ver detalle
                            </asp:LinkButton>

                            <!-- Botón para asignar (opcional) -->
                            <asp:Button ID="btnAsignar7" runat="server" CommandName="Asignar" CommandArgument='<%# Eval("Id_Ticket") %>' CssClass="btn btn-warning" Text="Asignarme" />
                        </div>
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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
                      <span class="badge bg-secondary"><%# Eval("Estado") %></span>
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

  <!-- Modal de detalle (sin cambios) -->
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

            <dt class="col-sm-3">Estado</dt>
            <dd class="col-sm-9">
              <asp:DropDownList ID="ddlDetEstado" runat="server" CssClass="form-select" />
            </dd>
          </dl>
        </div>
          <asp:Panel ID="calificacionEstrellas" runat="server" CssClass="mt-3">
          <div id="starsContainer" runat="server" class="stars text-center mb-3">
            <span id="star1" runat="server" class="star">&#9733;</span>
            <span id="star2" runat="server" class="star">&#9733;</span>
            <span id="star3" runat="server" class="star">&#9733;</span>
            <span id="star4" runat="server" class="star">&#9733;</span>
            <span id="star5" runat="server" class="star">&#9733;</span>
          </div>
          <!-- HiddenField para capturar en el postback si el usuario cambia la calificación -->
          <asp:HiddenField ID="hfCalificacion" runat="server" />
        </asp:Panel>

        <div class="modal-footer">
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.3/dist/sweetalert2.all.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
