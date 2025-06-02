<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.Master"
    CodeBehind="TodosLosTickets.aspx.cs"
    Inherits="AppWTM.TodosLosTickets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <link href="Styles/todoslostickets.css" rel="stylesheet" />

  <div class="container mt-4">
    <h2><asp:Label ID="lblTitulo" runat="server" Text="Tickets de Mi Área"></asp:Label></h2>
    <div class="row">
      <asp:Repeater ID="rptTicketsArea"
                    runat="server"
                    OnItemCommand="rptTicketsArea_ItemCommand"
                    OnItemDataBound="rptTicketsArea_ItemDataBound">
        <ItemTemplate>
          <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
            <!-- toda la tarjeta es un LinkButton que dispara VerDetalle -->
            <asp:LinkButton ID="lnkVerDetalle"
                            runat="server"
                            CssClass="card h-100 text-start text-decoration-none text-dark"
                            CommandName="VerDetalle"
                            CommandArgument='<%# Eval("Id_Ticket") %>'>
              <div class="card-body">
                <h5 class="card-title"><%# Eval("Título") %></h5>
                <p class="card-text mb-1"><%# Eval("Descripción") %></p>
                <div class="mb-2">
                  <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                  <span class="badge bg-secondary"><%# Eval("Estado") %></span>
                </div>
                <small class="text-muted">#<%# Eval("Id_Ticket") %> – <%# Eval("Fecha","{0:dd/MM/yyyy}") %></small><br />
                <small class="text-muted">Solicitante: <%# Eval("Usuario") %></small><br />
                <small class="text-muted">Agente: <%# Eval("Agente") %></small>
              </div>
            </asp:LinkButton>

            <!-- Botón Asignarme -->
            <asp:Button ID="btnAsignar"
                        runat="server"
                        CssClass="btn btn-sm btn-outline-primary mt-2"
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

  <!-- Modal de detalle -->
  <div class="modal fade" id="ticketDetalleModal" tabindex="-1" aria-hidden="true">
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

            <dt class="col-sm-3">Solicitante</dt>
            <dd class="col-sm-9"><asp:Label ID="lblDetSolicitante" runat="server" /></dd>

            <dt class="col-sm-3">Solicitante</dt>
            <dd class="col-sm-9"><asp:Label ID="lblFecha" runat="server" /></dd>

            <dt class="col-sm-3">Estado</dt>
            <dd class="col-sm-9">
              <asp:DropDownList ID="ddlDetEstado" runat="server" CssClass="form-select" />
            </dd>

            <dt class="col-sm-3">Descripción</dt>
            <dd class="col-sm-9"><asp:Label ID="lblDetDescripcion" runat="server" /></dd>

          </dl>
        </div>
        <div class="modal-footer">
          <asp:Button ID="btnCambiarEstado"
                      runat="server"
                      CssClass="btn btn-primary"
                      Text="Guardar cambios"
                      OnClick="btnCambiarEstado_Click" />
          <button type="button" class="btn btn-secondary"
                  data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script>
      function confirmAssign(btn) {
          Swal.fire({
              title: '¿Te asignas este ticket?',
              icon: 'question',
              showCancelButton: true,
              confirmButtonText: 'Sí, asignarme'
          }).then(result => {
              if (result.isConfirmed) {
                  __doPostBack(btn.name, '');
              }
          });
          return false;
      }
  </script>

  <!-- Bootstrap 5 bundle -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
