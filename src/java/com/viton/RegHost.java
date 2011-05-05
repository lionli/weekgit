/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton;

import com.viton.model.Host;
import java.util.List;
import java.util.Set;

/**
 *
 * @author lion
 */
public class RegHost {
    private List<Host> hosts;

    public void addHost(Host host){
        hosts.add(host);
    }

    public List<Host> getHosts(){
        return hosts;
    }
}
