<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="TodosLosTickets.aspx.cs" Inherits="AppWTM.TodosLosTickets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Cambiar el h2 fijo por un Label -->
        <h2><asp:Label ID="lblTitulo" runat="server" Text="Tickets de Mi Área"></asp:Label></h2>    
        <asp:HiddenField runat="server" ID="hidRepeaterID" />
        <asp:Repeater ID="rptTicketsArea" runat="server" OnItemCommand="rptTicketsArea_ItemCommand">
        <ItemTemplate>
            <div class="ticket-card mb-3 border rounded p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5><%# Eval("Título") %></h5>
                        <span class="badge bg-primary"><%# Eval("Prioridad") %></span>
                        <span class="badge bg-secondary"><%# Eval("Estado") %></span>
                    </div>
                    <div class="text-end">
                        <small class="text-muted">Ticket #<%# Eval("Id_Ticket") %></small><br/>
                        <small class="text-muted"><%# Eval("Fecha", "{0:dd/MM/yyyy HH:mm}") %></small>
                    </div>
                </div>
                <div class="mt-2">
                    <p class="mb-1"><%# Eval("Descripción") %></p>
                    <small class="text-muted">
                      Solicitante: <%# Eval("Usuario") %>
                    </small><br/>
                    <small class="text-muted">
                      Responsable: <%# Eval("Agente") %>
                    </small>
                </div>
                <asp:Button
                ID="btnAsignar"
                runat="server"
                Text="Asignarme"
                CssClass="btn btn-sm btn-outline-primary mt-2"
                CommandName="Asignar"
                CommandArgument='<%# Eval("Id_Ticket") %>'
                Visible='<%# Eval("Agente").ToString() == "Sin asignar" %>'
                OnClientClick='return confirmAssign(this);' />
            </div>
        </ItemTemplate>
    </asp:Repeater>
    </div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function confirmAssign(btn) {
        // btn.name es el UniqueID que WebForms espera para dispatch
        Swal.fire({
            title: '¿Te asignas este ticket?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Sí, asignarme'
        }).then(result => {
            if (result.isConfirmed) {
                // esta invocación dispara el postback al botón concreto:
                __doPostBack(btn.name, '');
            }
        });
        // siempre false para frenar el postback inmediato
        return false;
    }
</script>
</asp:Content>
