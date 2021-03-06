#include "X_misc.h"
#include "pixbuf.h"
#include "utils.h"
#include "xid2aid.h"
#include "dock_config.h"
#include "dominant_color.h"
#include "handle_icon.h"
#include "dock_hide.h"
#include "region.h"
#include "xdg_misc.h"
#include "dwebview.h"
int _is_maximized_window(Window win)
{
    gulong items;
    Atom ATOM_WINDOW_NET_STATE = gdk_x11_get_xatom_by_name("_NET_WM_STATE");
    Atom ATOM_WINDOW_MAXIMIZED_VERT = gdk_x11_get_xatom_by_name("_NET_WM_STATE_MAXIMIZED_VERT");
    Display* _dsp = GDK_DISPLAY_XDISPLAY(gdk_display_get_default());
    long* data = get_window_property(_dsp, win, ATOM_WINDOW_NET_STATE, &items);

    if (data != NULL) {
        for (guint i=0; i<items; i++) {
            if ((Atom)X_FETCH_32(data, i) == ATOM_WINDOW_MAXIMIZED_VERT) {
                XFree(data);
                return 1;
            }
        }
        XFree(data);
    }
    return 0;
}
gboolean dock_has_maximize_client()
{
    Atom ATOM_CLIENT_LIST = gdk_x11_get_xatom_by_name("_NET_CLIENT_LIST");
    Display* _dsp = GDK_DISPLAY_XDISPLAY(gdk_display_get_default());
    gulong items;
    Window root = GDK_ROOT_WINDOW();
    void* data = get_window_property(_dsp, root, ATOM_CLIENT_LIST, &items);

    gboolean has = FALSE;

    if (data == NULL) return has;

    for (guint i=0; i<items; i++) {
        Window xid = X_FETCH_32(data, i);
        if (_is_maximized_window(xid)) {
            has = TRUE;
            break;
        }
    }

    XFree(data);

    return has;
}


JS_EXPORT_API
void dock_draw_window_preview(JSValueRef canvas, double xid, double dest_width, double dest_height)
{
    GdkWindow* win = gdk_x11_window_foreign_new_for_display(gdk_display_get_default(), (long)xid);
    if (win == NULL) {
	return;
    }

    if (JSValueIsNull(get_global_context(), canvas)) {
        g_debug("draw_window_preview with null canvas!");
        return;
    }
    cairo_t* cr =  fetch_cairo_from_html_canvas(get_global_context(), canvas);

    if (cr == NULL) {
        return;
    }

    cairo_save(cr);
    //clear preview content to prevent translucency window problem
    cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR);
    cairo_paint(cr);
    cairo_restore(cr);

    int width = gdk_window_get_width(win);
    int height = gdk_window_get_height(win);

    cairo_save(cr);
    double scale = 0;
    if (width > height) {
        scale = dest_width/width;
        cairo_scale(cr, scale, scale);
        gdk_cairo_set_source_window(cr, win, 0, 0.5*(dest_height/scale-height));
    } else {
        scale = dest_height/height;
        cairo_scale(cr, scale, scale);
        gdk_cairo_set_source_window(cr, win, 0.5*(dest_width/scale-width), 0);
    }
    cairo_paint(cr);
    cairo_restore(cr);

    canvas_custom_draw_did(cr, NULL);
}

