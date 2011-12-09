#!/usr/bin/perl -w -- 

use Wx 0.15 qw[:allclasses];
use strict;

package MyFrame;

use Wx qw[:everything];
use base qw(Wx::Frame);
use strict;

sub new {
    my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
    $parent = undef              unless defined $parent;
    $id     = -1                 unless defined $id;
    $title  = ""                 unless defined $title;
    $pos    = wxDefaultPosition  unless defined $pos;
    $size   = wxDefaultSize      unless defined $size;
    $name   = ""                 unless defined $name;

    $style = wxDEFAULT_FRAME_STYLE 
        unless defined $style;

    $self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
    $self->SetTitle("Draw/Video Controls");
    
    $self->{Ctl_Videos_Sizer_2} = Wx::BoxSizer->new(wxVERTICAL);        # Top-level left-hand sizer (contains media)

# wxMEDIABACKEND_DIRECTSHOW     Use ActiveMovie/DirectShow. Requires wxUSE_DIRECTSHOW to be enabled, requires linkage with the static library strmiids.lib, and is available on Windows Only.
# wxMEDIABACKEND_QUICKTIME     Use QuickTime. Windows and Mac Only. NOTE: On Mac Systems lower than OSX 10.2 this defaults to emulating window positioning and suffers from several bugs, including not working correctly embedded in a wxNotebook.
# wxMEDIABACKEND_MCI         Use Media Command Interface. Windows Only.
# wxMEDIABACKEND_GSTREAMER    Use GStreamer. Unix Only. 
# wxMEDIABACKEND_WMP10        Windows Media Player 9 or 10
# wxMEDIABACKEND_REALPLAYER    Realplayer
# Blank             Allow to choose own player

    $self->{Ctl_Videos_Media}= Wx::MediaCtrl->new( $self, wxID_ANY, '', wxDefaultPosition, [400,300],0,  );
    $self->{Ctl_Videos_Media}->Show( 1 );
    $self->{Ctl_Videos_Media}->ShowPlayerControls(wxMEDIACTRLPLAYERCONTROLS_DEFAULT);
                                # or wxMEDIACTRLPLAYERCONTROLS_NONE
                                # wxMEDIACTRLPLAYERCONTROLS_STEP
                                # wxMEDIACTRLPLAYERCONTROLS_VOLUME
                                # wxMEDIACTRLPLAYERCONTROLS_DEFAULT

    $self->{Ctl_Videos_Sizer_2}->Add( $self->{Ctl_Videos_Media}, 0, 0, 0  );
    $self->{Ctl_Videos_ImageViewer_Panel_1} = Wx::Panel->new($self, wxID_ANY, wxDefaultPosition, [400,20], );
    $self->{Ctl_Videos_Sizer_2}->Add($self->{Ctl_Videos_ImageViewer_Panel_1}, 0, 0, 0);
    $self->{Ctl_Videos_Button} = Wx::Button->new($self, wxID_ANY, "Load", );
    $self->{Ctl_Videos_Sizer_2}->Add($self->{Ctl_Videos_Button}, 0, 0, 0);


    Wx::Event::EVT_PAINT($self->{Ctl_Videos_ImageViewer_Panel_1},\&paint);
    Wx::Event::EVT_BUTTON( $self, $self->{Ctl_Videos_Button}, \&on_media_load );

    $self->SetSizer($self->{Ctl_Videos_Sizer_2});
    $self->{Ctl_Videos_Sizer_2}->Fit($self);
    $self->Layout();

    return $self;
}
sub on_media_load {
#
#    Load file button selected
#
    my( $self, $event ) = @_;

    my $file = Wx::FileSelector('Choose a media file');    # Select video file
    if( length( $file ) ) {
        $self->{Ctl_Videos_Media}->LoadFile ($file);        # Load video file
    $self->{mediafile}= $file;            # Store location of video file in '$self
#    $self->{Ctl_Videos_Media}->Play();

    }
}
sub paint{
    my ($self,$event) = @_;
    my $dc = Wx::PaintDC->new($self);
    $dc->DrawRectangle( 0,0, 400,20 );
    $event->Skip;
}
package main;

unless(caller){
    local *Wx::App::OnInit = sub{1};
    my $app = Wx::App->new();
    Wx::InitAllImageHandlers();

    my $frame_1 = MyFrame->new();

    $app->SetTopWindow($frame_1);
    $frame_1->Show(1);
    $app->MainLoop();
}