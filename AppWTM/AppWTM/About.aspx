<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="AppWTM.About" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
     <link href="Styles/acercade.css" rel="stylesheet" type="text/css" />
  
    <main class="container mt-5">
        <h2 class="page-title"><%: Title %></h2>
        
        <section class="objetivo-section">
            <h3 class="text-secondary">Objetivo del Proyecto</h3>
            <p class="lead">
                Diseñar e implementar un sistema integral que permita gestionar las solicitudes de
                servicio de manera centralizada, con funciones avanzadas para categorizarlas automáticamente y
                asignarlas dinámicamente a las áreas correspondientes según la disponibilidad de recursos.
                Este sistema incluirá un módulo de reportes para analizar el rendimiento de las áreas en términos de
                tiempo de respuesta y carga de trabajo, además de garantizar una experiencia segura y personalizada
                mediante un sistema eficiente de autenticación y edición de perfiles, optimizando así la gestión interna y
                mejorando la eficiencia operativa en tiempo real.
            </p>
        </section>

        <section class="team-section">
            <h5 class="text-secondary">Integrantes</h5>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">Guerrero Jimenez Jesee Isaac</li>
                <li class="list-group-item">Martinez Vargas Brianda Aridel</li>
                <li class="list-group-item">Maurio Jimenez Luis Mario</li>
            </ul>
        </section>

        <section class="asesor-section">
            <h5 class="text-secondary">Asesor del Proyecto</h5>
            <p class="text-muted">José Manuel Hernandez Reyes</p>
        </section>

        <section class="image-section">
            <div class="img-container">
                <img src="Img/Fabrica_Software.jpeg" class="img-fluid" alt="Fábrica de Software">
                <p class="image-caption">Fábrica de Software</p>
            </div>
        </section>
    </main>
</asp:Content>